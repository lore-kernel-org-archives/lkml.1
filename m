Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZGFGcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZGFGcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZGFGcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:32:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56974 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbZGFGcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:32:16 -0400
Message-ID: <4A519A70.50801@petalogix.com>
Date: Mon, 06 Jul 2009 08:32:16 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
References: <4A4DFB77.1080700@petalogix.com> <200907031702.52612.arnd@arndb.de>
In-Reply-To: <200907031702.52612.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 03 July 2009, Michal Simek wrote:
>
>   
>> I am trying to solve problem with mmap syscall on Microblaze which I have.
>> I am running mmap01 test program from LTP. In attachment is hacked
>> version and inline version is below too.
>>     
>
> Does this happen on microblaze-mmu or microblaze-nommu, or both?
> The mmap code for the two is very different.
>   
For MMU code.

> What file system is backing the temporary file?
>   
I tested it on nfs and initramfs.
The behavior on both has the same symptoms but on initramfs is program
much faster
which is presumtive.

If I run that test, 10times or more and see the output. For example
first 4 tests failed the rest
passed. I look at cpu internals and from syscalls/context switch I see
that that 4 tests which failed
are not interrupted. The rest is interrupted and that tests passed. I
have accurate log for it if you want to see that behavior.
Interruption caused that "anything" in kernel give a time to finish any
work which caused that mmap
memory is consistent.
This behavior is seen in my previous email that depends on time when is
listing called.
Is there any part of kernel which should take care about it?

Thanks for any suggestion.


> For -nommu, there are a number of ristrictions from
> Documentation/nommu-mmap.txt, in particular, MAP_FIXED is
> forbidden, as is PROT_WRITE with regular files. 
>   
This test can'b be run on noMMU.


Michal



>  
>   
>> Arnd: Anyway maybe worth to move sys_mmap2 to any generic location. What
>> do you think?
>>     
>
> Yes, that would be good. I actually have a patch for that somewhere in
> my playground repository, but it build-breaks some architectures in the
> current state. I'm planning to fix that (and do the same for execve
> and maybe some of the other remaining arch specific syscalls) at some
> point.
>
> 	Arnd <><
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

