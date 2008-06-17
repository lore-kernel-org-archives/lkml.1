Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbYFQS3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbYFQS3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYFQS3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:29:18 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:51155 "EHLO
	mail102-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbYFQS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:29:18 -0400
X-BigFish: VPS-30(zf7I34a4lz542N14ffO4015M7efV1442Jzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4858024D.6010601@am.sony.com>
Date: Tue, 17 Jun 2008 11:28:29 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: [Fwd: Recommendation for activating a deferred module init in the
 kernel]
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2008 18:29:02.0048 (UTC) FILETIME=[04037E00:01C8D0A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry - I meant to copy this to linux-kernel and forgot.
This is a query I just sent to the linux-embedded list.
Please copy linux-embedded@vger.kernel.org on any replies.

-------- Original Message --------
Subject: Recommendation for activating a deferred module init in the kernel
Date: Tue, 17 Jun 2008 11:23:18 -0700
From: Tim Bird <tim.bird@am.sony.com>
To: linux-embedded <linux-embedded@vger.kernel.org>

Hi all,

I am working with a product team on bootup time issues.  One technique
that we are forward-porting from an old kernel (and that I thought I
might work on mainlining) is to compile modules statically into the kernel,
but defer their initialization until after boot time.

Normally, module init routines are declared with module_init(), which,
when they are statically linked into the kernel, uses the macro
__define_initcall() to add an entry to a special init segment.
This is called during bootup by do_initcall() (in init/main.c),
and the memory where the function resides is eventually freed.

There are several phases of initcalls (see include/linux/init.h),
including core, postcore, arch, subsys, fs, rootfs, device, and late.

In our modification, we:
 1) add another phase for deferred initcalls
 2) modify the module_init macro definition to use that phase, for the
 modules we wish to defer initialization of
 3) modify the free code to not free the memory until later
 4) add an ioctl to trigger the deferred initialization (and memory free)

One of the main sub-systems that we defer initialization of this
way is USB, and this saves quite a bit of time.  (Of course the
same, or slightly more CPU cycles are eventually used during
bootup time.  But this lets us get to user space quicker so we
can start user-visible applications faster.)

I'm not that happy using an ioctl for this trigger.  What is
the preferred method of activating a kernel feature like this?
I presume something in /proc or /sys, but I'm not sure.

Also, is there something like this in the kernel now that I'm
missing?

Any advice or comments would be welcome.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

