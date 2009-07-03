Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZGCFzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZGCFzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZGCFzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:55:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33521 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZGCFzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:55:14 -0400
Message-ID: <4A4D9D41.5090006@monstr.eu>
Date: Fri, 03 Jul 2009 07:55:13 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: John Williams <john.williams@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       John Linn <John.Linn@xilinx.com>, Michal Simek <monstr@monstr.eu>
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic
 header files for the ABI
References: <cover.1245345894.git.arnd@arndb.de> <4A4B49D0.2090101@monstr.eu> <1d3f23370907011552h5b3c96b9h208d5567e7a2a615@mail.gmail.com> <200907021136.07426.arnd@arndb.de>
In-Reply-To: <200907021136.07426.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Thursday 02 July 2009, John Williams wrote:
>> However, we've just "broken" the ABI in 2.6.31, if we merge further
>> ABI breakage in 2.6.32 it's more pain and confusion.
>>
>> So, unless we can merge and validate this ABI breakage during the
>> 2.6.31-rc cycle, I think we need to hold on changes that would break
>> the ABI again, so soon.
>>
>> Longer term there will be a complete redo of glibc up to the latest
>> version, which will obviously require a new toolchain for users - I
>> think that is the right place to do the next round of ABI breakage.
>>
>> Any thoughts?
> 
> Normally the rule is to never break the ABI at all, even in a major
> update of glibc.
> 
> Initially I had hoped that we could do the change before 2.6.30 and
> I worked hard on getting the ABI patches to you early enough for
> that. After that failed, I made sure that you had everything in
> place for 2.6.31 and I believed that Michal said he would integrate
> that in the microblaze-mmu merge, before you actually start seeing
> users on the mainline kernel.

we are talking about minor change - I know it break ABI a little bit
but don't be scared with it.
Two changes - first ssize_t is no problem - just warning messages
Second change kernel_mode_t from short to int breaks only ipc structures.
We are working on solving problem about another IPC trouble. I found a problem with
some syscalls which needs to be fixed in kernel and glibc - we will need newest toolchain
for it in any case. John just wanted to be sure that we will have working correct version.
I added most of your patches to my next branch for testing. I expect that Stephen merge it to next soon.

Thanks for your work,
Michal


> 
> If we don't get that into 2.6.31 any more (and the chances
> have slimmed down a lot after the end of the merge window), I
> think we should just declare complete failure and not touch
> the ABI any more, however broken it may be. 
> 
> In over 14 months, not even the most basic fixes to the ABI
> that I mentioned in the first review have been applied:
> 
> On Tuesday 15 April 2008, Michal Simek wrote:
>> Arnd Bergmann wrote:
>>> * Your syscall ABI is largely obsolete. A third of the syscalls you
>>> define should not even be there in the first place as they have been
>>> replaced by newer versions. E.g. you have select, _newselect and pselect6,
>>> where just pselect6 would be sufficient -- you don't need to worry about
>>> backwards compatibility if you don't have existing code. A good start
>>> would be to take the arch/blackfin syscall list and further reduce it
>>> from there. Further examples are:
>>> - replace socketcall with separate syscall entry points
>>> - replace ipc with a separate entry points
>>> - remove all the legacy signal handling from arch/microblaze/kernel/signal.c
>>> - remove sys_mmap, sys_olduname and sys_vfork
>>> - finally define a generic sys_mmap2 and sys_uname in kernel/ so you don't
>>>   need another copy in arch/microblaze/kernel
>>> - Use 64 bit off_t, and 32 bit uid_t, gid_t etc.
>> This kernel don't need to keep backward compatibility. No one will port to
>> previous version. I'll look at your points and I'll send you what I do.
> 
> 	Arnd <><
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
