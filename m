Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbYJYA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbYJYA4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYJYA4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:56:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:42615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJYA4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jYf5NrVcu937ALPuwbQdg5SARciqFPIvFLGnk1YxZ09e7rI1kajeEWHYGgzC82jAz2
         YFA59Hx6wcsxSfoZvyAbELo0tFqmUbgL+GnDseC915qh2KcUqkS7DgGPlDW78gGq2LYa
         7l37x2Igszah3RgC2DrDROiAy5SYCyUnhqd5I=
Message-ID: <804dabb00810241756x2b7a35e0v8593451285582267@mail.gmail.com>
Date: Sat, 25 Oct 2008 08:56:07 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
Cc: zanussi@comcast.net, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1224857756.5519.5.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <804dabb00810232144w4a618737l28c1d63108594d1e@mail.gmail.com>
	 <1224857756.5519.5.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9P0uNdq029660

ok.   just ignore it.   i think based on "git log" of"git://repo.or.cz/linux-2.6/kmemtrace.git":
commit 0441e5ff6ab71cf7a3e9ec3116f14d0fd7d20d51Author: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>Date:   Thu Jul 10 20:20:05 2008 +0300
    kmemtrace: SLOB hooks.
the repo seemed way out of date.   But a clone of Pekka's slab-2.6'stopic/kmemtrace branch have no problem.   The steps are as follows:
1.   git clone git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git2.   git checkout -m  origin/topic/kmemtrace3.   git checkout -b kmemtrace
git log gives:
commit 51b19be3535c8fbcce6b6f838d89b9a6a4cc5b92Author: Tom Zanussi <zanussi@comcast.net>Date:   Fri Oct 10 23:58:51 2008 -0500
    relayfs: fix infinite loop with splice()
But the userspace tool I still get it from: git://repo.or.cz/kmemtrace-user.git
Correct?
Now I have some problems:
a.   I would like to extract out all the commit as diff - may I knowhow to do that? ("git log" only gives the descriptive part).b.   boot-time memory profiling....how can it be done (or extractedout)?  (kmemtrace-user does not have that?)c.   please provide some pointers to documentation:   how do Iinterpret the following:
Allocation #83468 (CPU0) already exists!        by __kmalloc_track_caller+25        last touched by __kmalloc_track_callerAllocation #83740 (CPU0) already exists!        by __kmalloc_track_caller+25        last touched by __kmalloc_track_caller
For my purpose, I would like to trace how and where is memoryallocated - just one one single userspace program which access themmap("/dev/mem") to read the memory.   How can it be done?   "Tracingmemory" in my context will mean list all the kernel-function +memory-allocated-within-the-function + its-PFN-or-PTE-information (topinpoint the exact physical page).   My understanding is that thesecan be done, via checking the value of "current", as each userspaceprogram started will have a unique "current" context value, andtherefore within any kernel function, just check this value, to focustracing on just one particular userspace program.   Correct?
d.   The following:
/sys/kernel/debug/kmemtrace>ls -al×Ü¼Æ 0drwxr-xr-x 2 root root          0 2008-10-25 .drwxr-xr-x 9 root root          0 2008-10-25 ..-r-------- 1 root root          0 2008-10-25 abi_version-r-------- 1 root root 2946936192 2008-10-25 cpu0-r-------- 1 root root 1701263952 2008-10-25 cpu1-rw------- 1 root root          0 2008-10-25 enabled-r-------- 1 root root          0 2008-10-25 total_overruns
So the information is stored in memory, right?   Is it possible toreset it?   I don't want these information to clog up the memory.
e.   The balance between cpu0 and cpu1 does not seemed equal, anyimplications on the scheduler/ IO Scheduler?   or memory allocationscheduler (if there exists one :-))....sorry about that....myknowledge is limited.
On Fri, Oct 24, 2008 at 10:15 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:> On Fri, 2008-10-24 at 12:44 +0800, Peter Teoh wrote:>> after doing a>>>> git clone git://repo.or.cz/linux-2.6/kmemtrace.git>>>> I reboot the OS and encountered several application crashes.....the>> logs are as per attached....please comment.>>>> for bug0 and bug1, the system go into a state of complete>> non-responsive, even connecting via SSH into the system becomes>> impossible, and bug0 and bug1 was generated just before it goes into>> this state.>>>> for bug2, the mouse seemed to respond, i managed to output the dmesg>> (which is bug2 itself).>>>> any comments?>> Hmm, you're hitting out-of-memory. I can't immediately see how kmemtrace> is at fault here. Eduard, thoughts?>>


-- Regards,Peter Teohÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
