Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYHIVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYHIVcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHIVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:32:13 -0400
Received: from ppp-111-251.adsl.restena.lu ([158.64.111.251]:42094 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751694AbYHIVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:32:12 -0400
Date: Sat, 9 Aug 2008 23:32:09 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: <JosephChan@via.com.tw>
Cc: akpm@linux-foundation.org, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, geert@linux-m68k.org
Subject: Re: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer
 Device Driver
Message-ID: <20080809233209.543756ba@neptune.home>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698C@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698C@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 August 2008 <JosephChan@via.com.tw> wrote:
> Here comes the 13 updated patchs for VIA Frame Buffer Device Driver.
> This driver could be used on VIA UniChrome (Pro) and Chrome9 family
> chips. All the patches are based on linux kernel 2.6.27-rc2

Seems to work for me when compiled into kernel on Commell LE365D (Via
CX700) though I get two unwanted effects:
- boot logo does not show up, where it should appear I just get a
  square of colored pixels (2 colors: background and foreground grid)
- when blanking console colored text remains visible (e.g. green '*'
  characters emitted during Gentoo boot)
  Ideally the output/monitor should got into standby when console is
  blanking


The boot logo issue exists when patch is applied to 2.6.26.2 and
2.6.27-rc2-git4, for the console blanking it's only tested on 2.6.26.2
as 2.6.27-rc2-git4 panics while probing hard drives.

Framebuffer related kernel commandline options:
  video=viafb:viafb_mode=1280x1024,viafb_bpp=32,viafb_refresh=60


Suspend to RAM (S3) works with BIOS configured to reinitialize the
graphics at resume time, I have not yet checked without this option
being enabled in BIOS (though it probably won't work as there is no
suspend/resume callback in the patch-set).
Have not checked yet if DRI has support for CX700 and can do the
suspend/resume handling as the intel DRI can do.


As Krzysztof Helt I'm in favor of merging and ironing out remaining
issues with incremental patches

Bruno
