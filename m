Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYJPOR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYJPOR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYJPORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:17:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYJPORp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:17:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: Suspend/resume regression between 2.6.26 and 2.6.27-rc1
Date: Thu, 16 Oct 2008 16:21:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, "linux-acpi" <linux-acpi@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>, mingo@elte.hu
References: <1223625973.2735.142.camel@rzhang-dt> <200810101441.14123.rjw@sisk.pl> <1224143818.3944.68.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1224143818.3944.68.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810161621.54864.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 16 of October 2008, Zhao Yakui wrote:
> On Fri, 2008-10-10 at 14:41 +0200, Rafael J. Wysocki wrote:
> > On Friday, 10 of October 2008, Zhang Rui wrote:
> > > Hi, len,
> > > 
> > > this is the ACPI regression test result based on the latest ACPI test branch.
> > > 
> > > 1. on ﻿Acer:(AMD CPU, VIA chipset. 64 bit kernel)
> > > ﻿When doing S3 test, after pressing the power button, the system
> > > reboots instead of resuming. But if S3 is done after S4, the system can
> > > resume very well after pressing power button or using the RTC
> > > alarm.
> > > Note that this is an upstream regression as it can be reproduced on
> > > linus' tree.
> > > Yakui is investigating this issue.
> > 
> > We had some reports of the second suspend (S3) failure too, where the second
> > attempt to suspend to RAM (or to resume from it) failed after a successful
> > one.  I wonder if that's related.
> Some suspend/resume tests are done on one Acer laptop(AMD CPU, VIA
> chipset, 64-bit kernel).
>    The system will be rebooted when pressing power button after the box
> enters S3 state. But if S3 is done after doing S4, the system can be
> resumed very well after pressing power button.This issue can be
> reproduced on the upstream kernel.
> 
> After the further test we can confirm that this is a regression. The
> 2.6.26 kernel can work well on this box. But the 2.6.27-rc1 will fail.
> 
> After using the git-bisect it is confirmed that the commit
> 736f12bff9d9e7b4e895c64f73b190c8383fc2a1 is good. 
>     >commit 736f12bff9d9e7b4e895c64f73b190c8383fc2a1
>     >Author: Glauber Costa <gcosta@redhat.com>
>     > Date:   Tue May 27 20:14:51 2008 -0700
>        >x86: don't use gdt_page openly.
> 
> And the commit 
> 55f262391a2365d657a00ed68edd1a51bca66af5 is bad. 
>    >commit 55f262391a2365d657a00ed68edd1a51bca66af5
>    >Author: Yinghai Lu <yhlu.kernel@gmail.com>
>    >Date:   Wed Jun 25 17:54:23 2008 -0700
>     >x86: rename setup_32.c to setup.c
> 
>   The patches between the above two commits are related with X86. When
> using git-bisect between the above two commits, we will get the
> compiling errors(For example: some files don't exist) or the kernel
> panic. So we can't continue using git-bisect to identify which commit
> the regression is caused by.

If you test SMP kernels on a non-SMP box, that may be
http://bugzilla.kernel.org/show_bug.cgi?id=11568.  In which case, please test
the patch from http://bugzilla.kernel.org/show_bug.cgi?id=11568#c46 .

Thanks,
Rafael
