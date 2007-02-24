Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbXBXSKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbXBXSKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 13:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbXBXSKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 13:10:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933532AbXBXSKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 13:10:49 -0500
Date: Sat, 24 Feb 2007 10:07:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
Message-Id: <20070224100729.8675b425.akpm@linux-foundation.org>
In-Reply-To: <20070224175424.176030@gmx.net>
References: <20070224175424.176030@gmx.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 24 Feb 2007 18:54:24 +0100 "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> Hi folks,
> Second attempt now:
> I already reported to Linus Torvalds and Andrew Morton that it is impossible to mount a conventional floppy drive without hanging up the whole system.
> Andrew's reaction was quite ambiguous: "We did not break it"

Sorry, what I meant was "Neither Linus nor I broke it".  ie: please report
this in a place where the person who did break it can see it.  This you have
done.

> Once again and for the last time: I do not state that floppy.c is broken. I only state that it is immpossible to mount a floppy drive with kernel 2.6.21-rc1-git1. Kernel 2.6.20 is OK. But 2.6.21-rc1-git1 is definitely buggy!
> I did some work already:
> a. I copied the following modules from the intact and sane kernel 2.6.20 into the 2.6.21-rc1-git1 tree:
> cdrom.h, floppy.c, init.h, io.h, proc_misc.c, setup.c, timer.h, uaccess.h
> b. I adjusted some hunks of the patch for module main.c (part of patch-2.6.21-rc1) to make the kernel compile without errors.
> But the problem still persists, and I do not have any idea anymore where the offensive hunks in patch-2.6.21-rc1 could reside.
> 
> Questions:
> a. Can someone please confirm the described problem?
> b. Can someone please take action to find out where the buggy code resides?
> c. Why is this untested material being pushed into main vanilla - what is going on at kernel.org please?
> 
> Please take action! The bug was introduced somewhere at the transition of 2.6.20 towards 2.6.20-git14.
> 

I think we'll find that it works OK for hundreds of other people, so it got
broken in some manner which is specific to a very small number of machines,
of which yours is one.

If that theory proves to be correct, I'm afraid that the most proactical
way of fixing this is to ask you to run a git-bisect to find the changeset
which introduced the regression.


