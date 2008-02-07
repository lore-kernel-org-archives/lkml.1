Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYBGKqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYBGKqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYBGKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:46:25 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29984 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbYBGKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:46:24 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: OOPS in sysctl.c
Date: Thu, 7 Feb 2008 11:46:12 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200802050845.58691.hs4233@mail.mn-solutions.de> <20080206002420.91124dab.akpm@linux-foundation.org> <20080206190353.GB1732@martell.zuzino.mipt.ru>
In-Reply-To: <20080206190353.GB1732@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071146.12726.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 20:03:53 you wrote:
> Please, post .config and "ls -lR /proc/sys" output _before_
> suspend/resume.

Just a note: I don't use vanilla v2.6.24, but v2.6.24 plus a 
bunch of patches on top of it. I minimized them and for v2.6.24, 
this is the minimal number of patches needed to get the device 
up & running and also supending & resuming:

$ quilt series
+ rt3000-core.patch
+ rt3000-defconfig.patch
+ rt3000-smc91x-mac.patch
+ mn-keyb.patch
+ mn-smc91x.patch
+ mn-suspend-ignore-console.patch
= ARM-pxa-fix-PXA27x-resume.patch

rt3000-core: this is the RT3000/RT4000 machine specific code, 
mostly in arch/arm/mach-pxa

rt3000-smc91x-mac.patch: code that put's a random MAC into the 
smc91x chip

mn-keyb.pm: my keyboard driver

mn-smc91x.patch: port and IRQ definitions for the SMC91111 
ethernet chip

mn-suspend-ignore-console.patch: a patch for kernel/power/main.c 
that puts #if 0...#endif around all calls to 
pm_prepare_console(), pm_restore_console(), suspend_console() 
and resume_console(). Without this patch the device would hang 
while suspending.

ARM-pxa-fix-PXA27x-resume.patch: the same as "git show 
dd01b2fc79a567ae03d0c96ddf61eb4de729d36d" from linux-git. 
Without this patch, the device would hang while resuming.

I'm using the first 6 patches since 2.6.13-rc2, just with little 
updates to the changing API or changing Makefile/Kconfig files. 

When I apply exactly the same 6 patches to v2.6.24-7284-g9ef9dc6, 
then the OOPS doesn't happen. Therefore I assume that the 
culprit is not in one of these patches. It might just be 
important :-)
