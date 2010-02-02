Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0BBKSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:18:31 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64415 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0BBKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:18:26 -0500
Message-ID: <4B67FB74.4030409@petalogix.com>
Date: Tue, 02 Feb 2010 11:16:20 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 1 Feb 2010, Michal Simek wrote:
>> Hi Peter and Linus,
>>
>> commit 221af7f87b97431e3ee21ce4b0e77d5411cf1549 breaks anything on Microblaze.
> 
> Gaah. My original version of that patch very much tried to make it a no-op 
> semantically, but then Peter made some preparatory changes for the next 
> patch, so it actually changes semantics a bit. I was expecting that to be 
> benign, but clearly there are issues.

Would it be possible to cc me or send that patches to linux-next? I am 
doing every day tests and report results on my site. I would be able to 
catch up bugs earlier.

> 
>> None reported any problem that's why I think that is Microblaze related.
> 
> Well, our previous handling of the critical stage of 'execve()' when we 
> actually switch from the old process to the new was _so_ grotty that many 
> architectures ended up playing some really subtle games there. The whole 
> point of the patch is to get rid of the games, but it's entirely possible 
> that Microblaze (and others) had crazy things going on that broke when we 
> made the ordering more straightforward.
> 
> That said, Microblaze is not one of the architectures I would have 
> expected to have problems. It has one of the most straightforward 
> "flush_thread()" implementations in the whole kernel (it's a no-op ;), and 
> that's where most of the hacky things were for the architectures that 
> needed the change. And it has no "arch_pick_mmap_layout()" issues or 
> anything else that tends to depend on personality bits or whatever.
> 
> Microblaze is a no-MMU platform, isn't it? 

Microblaze has support for both platforms MMU and noMMU. Only MMU 
version is affected. noMMU version is without any problem.

Which binary format does it
> use? It looks like _some_ binaries work (it seems to happily be running a 
> shell to actually do those startup scripts) while others have problems. Is 
> there a difference between "/bin/sh" and the binaries that seem to be 
> problematic (like /bin/mount and /bin/ifup).

Most of them is busybox ELF with shared libraries. I tried non-shared 
ELF and the problem is the same.

> 
> Are the failing binaries all setuid ones, for example? Or shared vs 
> non-shared? Or ELF vs FLAT or whatever?

no setuid.

Thanks,
Michal


> 
> 		Linus


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
