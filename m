Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXI3Pxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXI3Pxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXI3Pxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:53:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51844 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbXI3Pxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:53:43 -0400
Date: Sun, 30 Sep 2007 17:53:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Luebbe <jluebbe@lasnet.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] fix console change race exposed by CFS
Message-ID: <20070930155328.GE24077@elte.hu>
References: <1191084471.24185.11.camel@polaris> <20070930072056.GA18108@elte.hu> <1191141065.10375.9.camel@polaris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191141065.10375.9.camel@polaris>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Luebbe <jluebbe@lasnet.de> wrote:

> I'm currenly porting the OpenMoko patchset to 2.6.23-rc8. We are using 
> psplash and kdrive. When booting, I got an error from psplash about 
> being unable to switch consoles. Strangely, it was possible to start 
> kdrive manually. So i set up qemu for kernel debugging, set some 
> interesting breakpoints and then saw that it was scheduling away 
> directly after the kill_pid. Then it was quite obvious.
> 
> It was triggering every time, on the device and in qemu identically. 
> Most people testing the RCs probably don't run psplash (or any other 
> program which sets vt_mode.mode to VT_PROCESS), so it wasn't noticed 
> earlier.

thx for the description. I did some searching on google.com/codesearch, 
and here are some other console apps that make active use of VT_PROCESS:

   1diskxwin-2.0.0/X11/programs/Xserver/hw/kdrive/linux/linux.c
   usr/include/dev/wscons/wsdisplay_compat_usl.c
   busybox-1.01/loginutils/vlock.c
   allegro-4.2.2/src/linux/vtswitch.c
   tvision/classes/linux/linuxkey.cc
   xc/programs/Xserver/hw/xfree86/os-support/pmax/pmax_init.c
   aalib-1.4.0/src/aalinuxkbd.c
   qt-embedded-opensource-4.0.0-b2/src/gui/embedded/qkbdtty_qws.cpp
   mc-4.5.55/src/cons.handler.c
   psplash-0.1/psplash-console.c
   quakeforge-0.5.5/libs/video/targets/vid_fbdev.c

just in case someone has a regression with any of them, on an older 
kernel. To me it appears X should have triggered this too. Perhaps 
people dont switch between VGA and X all that frequently anymore ...

	Ingo
