Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZLCHkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZLCHkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZLCHkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:40:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63950 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZLCHkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:40:14 -0500
Message-ID: <4B176B50.4050901@petalogix.com>
Date: Thu, 03 Dec 2009 08:40:00 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for December 3
References: <20091203180214.16e452ed.sfr@canb.auug.org.au>
In-Reply-To: <20091203180214.16e452ed.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stephen Rothwell wrote:
> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Michael Neuling has written an interesting blog entry
> (http://neuling.org/mikey/index.cgi/tech/linux-next-size.html) about some
> stats he has gathered.
> 
> Changes since 20091202:
> 
> New tree: kbuild-current
> 
> The powerpc tree lost its build failure.
> 
> The ext3 tree gained a build failure for which I reverted a commit.
> 
> The net tree lost a conflict.
> 
> The mtd tree gained a conflict against the mips tree.
> 
> The tip tree lost a conflict.
> 
> The workqueues tree lost its conflicts.

todays tree is working on MMU microblaze correctly without any visible 
problem but noMMU microblaze kernel still have that bug as I reported 
some days ago.

Thanks,
Michal


Calibrating delay loop... 116.32 BogoMIPS (lpj=581632)
Mount-cache hash table entries: 512
------------[ cut here ]------------
WARNING: at include/linux/percpu.h:157 __create_workqueue_key+0x6c/0x194()
Modules linked in:

Stack:
   9f823f1c 902642ec 00000000 00000000 901d1ac4 90011a1c 901cc458 901d1ac4
   0000009d 90024308 000005b6 000005b7 9f801920 00000000 00000000 901d1adc
   90024300 00000000 902755a4 902755a4 00000000 00000000 901d1adc 90263174
Call Trace:

[<902642ec>] spawn_softlockup_task+0x0/0xb0
[<90011a1c>] warn_slowpath_null+0xc/0x20
[<90024308>] __create_workqueue_key+0x6c/0x194
[<90024300>] __create_workqueue_key+0x64/0x194
[<90263174>] init_workqueues+0x48/0xa0
[<9025c104>] kernel_init+0x0/0x164
[<9025c140>] kernel_init+0x3c/0x164
[<9025c168>] kernel_init+0x64/0x164
[<900019d8>] kernel_thread_helper+0xc/0x20
[<900019cc>] kernel_thread_helper+0x0/0x20

---[ end trace 139ce121c98e96c9 ]---
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource microblaze_clocksource
NET: Registered protocol family 2
microblaze_timer_set_mode: oneshot



> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 154 trees (counting Linus' and 21 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Jan Dittmer for adding the linux-next tree to his build tests
> at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
> Dunlap for doing many randconfig builds.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
