Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYCCRAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYCCRAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYCCRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:00:40 -0500
Received: from mga06.intel.com ([134.134.136.21]:41978 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbYCCRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:00:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,438,1199692800"; 
   d="scan'208";a="349080089"
Message-ID: <47CC2A3D.1000307@linux.intel.com>
Date: Mon, 03 Mar 2008 08:41:33 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu>
In-Reply-To: <20080303091304.GA17911@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> Could you try to hack up a debug patch perhaps? Uninline the 
>> fucntion(s) then add two versions (one is that breaks on your box and 
>> one is that works on your box) of this same pmd_bad()/pud_bad() 
>> functions and do something like this (pseudocode):
> 
> i.e. something like the (tested) patch below. It is not clear whether 
> your testcase is on 32-bit or 64-bit - so i went for the more likely 
> 32-bit case first.


------------[ cut here ]------------
WARNING: at arch/x86/mm/pgtable_32.c:387 pmd_bad+0x44/0x53()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #14
  [<c0424ba5>] warn_on_slowpath+0x41/0x67
  [<c0408c5c>] ? native_sched_clock+0x94/0xa6
  [<c043f432>] ? lock_release_holdtime+0x1a/0x115
  [<c04702d4>] ? handle_mm_fault+0x297/0x7e2
  [<c063eee6>] ? _spin_unlock+0x1d/0x20
  [<c04707f0>] ? handle_mm_fault+0x7b3/0x7e2
  [<c04851c1>] ? do_sync_read+0xab/0xe9
  [<c0417223>] pmd_bad+0x44/0x53
  [<c046f37f>] follow_page+0x8b/0x1f2
  [<c0470aa0>] get_user_pages+0x281/0x2ef
  [<c0488dec>] get_arg_page+0x2d/0x79
  [<c04f63cd>] ? strnlen_user+0x2f/0x4d
  [<c0488efb>] copy_strings+0xc3/0x160
  [<c0488fb4>] copy_strings_kernel+0x1c/0x2b
  [<c048a109>] do_execve+0x11a/0x1f0
  [<c0403351>] sys_execve+0x29/0x51
  [<c0404ac6>] syscall_call+0x7/0xb
  [<c0407697>] ? kernel_execve+0x17/0x1c
  [<c04021d1>] ? _stext+0x69/0x12c
  [<c040574f>] ? kernel_thread_helper+0x7/0x10
  =======================
---[ end trace 63b854b89f6f375d ]---



