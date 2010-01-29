Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870Ab0A2RBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0A2RBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701Ab0A2RBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:01:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37077 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab0A2RBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w93/bBP0bgI8oGvTEJGSZcnbiClDkwBLr6SocpkC4TE/Ia8nhw+mCnGm01qKe7rzsF
         74buIZ1yNFRp2xu/Itrqd60dOpvHt89TjYDVldRoXIhubb85vuJibK/KVwuAYZjde5qv
         grR8Ml75gEAqYaEHEp7VLRgLJnySE7fEH6jfU=
Subject: SCHED_DEADLINE for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: loongson-dev <loongson-dev@googlegroups.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: faggioli@etis.sssup.it, raistlin@inux.it,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>, Qingguo Zhou <zhouqg@gmail.com>,
       zhangfx <zhangfx@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sat, 30 Jan 2010 00:54:52 +0800
Message-ID: <1264784092.21670.81.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

Just made SCHED_DEADLINE run on my YeeLoong laptop ;)

SCHED_DEADLINE made by Dario Faggioli and Michael Trimarchi, is "a new
scheduling class called SCHED_DEADLINE for the Linux kernel. The
scheduling class implements the real-time scheduling algorithm called
Earliest Deadline First (EDF), one of the most common real-time
scheduling algorithms."

Its homepage:

http://www.evidence.eu.com/content/view/313/390/

and more information about it is available here:

http://gitorious.org/sched_deadline/pages/Home

Thanks very much to the authors, I just cloned it and did some necessary
modification for MIPS to make it work on my YeeLoong laptop with debian
6.0(squeeze), at last, I got a really "deterministic" laptop.

And the information about "SCHED_DEADLINE for MIPS" is listed as
follows:

1. sched_deadline for MIPS

I have put it here:

git://dev.lemote.com/rt4ls.git rt/2.6.31/sched-deadline

It is based on:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
rt/2.6.31

and

git://gitorious.org/sched_deadline/linux-deadline.git rt-deadline

and the following commits are added(please get more info from the git
repo.):

	SCHED_DEADLINE: added system calls for MIPS
	SCHED_DEADLINE: Fixup of "BUG: scheduling while atomic"

NOTE: If you plan to run it on your board, please remember to add your
board specific RT-preempt support at first.

2. sched_tool for MIPS

git://dev.lemote.com/rt4ls.git rt/schedtool-deadline

The schedtool is based on:

git://gitorious.org/sched_deadline/schedtool-deadline.git

To make the schedtool work on MIPS machine with debian O32 ABI system, I
have fixed the timespec struct and of course, the related system calls'
numbers are added in.

3. Usage (only use YeeLoong as an example)

3.1 Get the latest kernel with RT-preempt and SCHED_DEADLINE support

git://dev.lemote.com/rt4ls.git rt/2.6.31/loongson

3.2 Compile the kernel

A minimal defconfig is provided:

arch/mips/configs/yeeloong_rt_defconfig

and please refer to:

http://www.gitorious.org/sched_deadline/pages/Compile
http://dev.lemote.com/code/rt4ls/wiki/linux-loongson-howto

3.3 Get the schedtool with SCHED_DEADLINE support and compile it

git://dev.lemote.com/rt4ls.git rt/schedtool-deadline

3.4 Run your application with the SCHED_DEADLINE

$ ./schedtool -E -d 100000 -b 10000 -e yes

-E using the SCHED_DEADLINE policy(the old name is SCHED_EDF)
-d deadline
-b budget(runtime)
-e start command with specified policy/priority

Did you want to do some benchmarking on the RT-preempt and
SCHED_DEADLINE for MIPS? please refer to the "Benchmarks and Test Cases
" part of http://rt.wiki.kernel.org and the "Usage, Evaluation,
Examples" parts of http://gitorious.org/sched_deadline/pages/Home

That's all, Enjoy it!

Best Regards,
	Wu Zhangjin

