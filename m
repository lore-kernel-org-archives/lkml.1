Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbXH0RZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbXH0RZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXH0RZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:25:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57824 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbXH0RZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:25:39 -0400
Date: Mon, 27 Aug 2007 19:26:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
Message-ID: <20070827172654.GA21871@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 03:54:49PM +0100, Hugh Dickins wrote:
> Hi Roman,
> 
> I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> make oldconfig seems to turn it on even when nothing wants it,
> increasing kernel size by about 10k; but if you then edit the
> line out of .config and make oldconfig again, it correctly
> offers the choice and lets it be turned off after all.
> 
> (I've not actually tried make anything_else_config.)
> 
> Attached is a 2.6.23-rc1 i386 SMP .config, CONFIG_HOTPLUG_CPU
> not set, with which it should be easy to reproduce the issue: just
> make oldconfig in an -rc2 or current kernel tree (being sure to
> choose N for SUSPEND and HIBERNATION: those rightly select it).

I tried to reproduce this with no luck:

$ mv hugh .config 
$ make 
scripts/kconfig/conf -s arch/i386/Kconfig
*
* Restart config...
*
*
* Power management options (ACPI, APM)
*
Power Management support (PM) [Y/n/?] y
  Legacy Power Management API (DEPRECATED) (PM_LEGACY) [N/y/?] n
  Power Management Debug Support (PM_DEBUG) [N/y/?] n
Suspend to RAM and standby (SUSPEND) [Y/n/?] (NEW) n              <= I selected 'n'
Hibernation (aka 'suspend to disk') (HIBERNATION) [N/y/?] (NEW) n <= I selected 'n'
*
* Fusion MPT device support
*
Fusion MPT ScsiHost drivers for SPI (FUSION_SPI) [Y/n/m/?] y
Fusion MPT ScsiHost drivers for FC (FUSION_FC) [N/m/y/?] n
Fusion MPT ScsiHost drivers for SAS (FUSION_SAS) [N/m/y/?] n
Maximum number of scatter gather entries (16 - 128) (FUSION_MAX_SGE) [128] 128
Fusion MPT misc device (ioctl) driver (FUSION_CTL) [N/m/y/?] n
Fusion MPT logging facility (FUSION_LOGGING) [N/y/?] (NEW) 
#
# configuration written to .config
#
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
make: *** [_all] Interrupt

$ grep HOTPLUG_CPU .config
# CONFIG_HOTPLUG_CPU is not set

If you let kbuild do a silentoldconfig then I expect
it to be set due to SUSPEND being set.

If you can still reproduce it could you then explan the
exect stepts to do so.

PS. I used latest -linus as of yesterday.

	Sam
