Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbYBPAcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbYBPAcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYBPAb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:31:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53496 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYBPAb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:31:57 -0500
Date: Sat, 16 Feb 2008 00:31:36 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080216003136.GG31474@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
	torvalds@linux-foundation.org
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080216000943.GD31474@flint.arm.linux.org.uk> <20080215162121.317c7c1c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215162121.317c7c1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:21:21PM -0800, Andrew Morton wrote:
> On Sat, 16 Feb 2008 00:09:43 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > For reference, even _I_ don't build test the entire set of ARM defconfigs -
> > at about 7 minutes a build, 75 defconfigs, that's about 9 hours...  I
> > just build those which are important to myself, hope that the others are
> > fine, and rely on kautobuild finding any breakage.
> > 
> 
> you need a better box ;)

Maybe - it's a lowly 2.6GHz P4 with 1GB RAM, ICH5, and SATA disk.

> cerfcube_defconfig:				35 seconds
> carmeva_defconfig:				23 seconds
> spitz_defconfig (one of the biggest):		45 seconds
> 
> so would a stupid `for i in arch/arm/configs/*' script be sufficient
> coverage?

It will certainly improve the situation significantly, and pick up
on some non-ARM problems like (badge4_defconfig, since 2.6.24-git2):

drivers/built-in.o: In function `v4l2_i2c_attach':
drivers/media/video/v4l2-common.c:1035: undefined reference to `i2c_attach_client'

Currently, the defconfigs known to fail (long term) in Linus' tree
are clps7500_defconfig and trizeps4_defconfig - the former I'm tempted
to remove, the latter seems to be because the PCMCIA changes were lost
on the linux-pcmcia list and the trizeps folk have probably given up.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
