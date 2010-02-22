Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0BVRUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:20:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0BVRUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:20:23 -0500
Message-ID: <4B82BCB0.9060903@zytor.com>
Date: Mon, 22 Feb 2010 09:19:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, sliakh.lkml@gmail.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       jiang@cs.ncsu.edu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com> <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org> <20100222105457.GA31148@elte.hu> <20100222110106.GA7206@elte.hu>
In-Reply-To: <20100222110106.GA7206@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 03:01 AM, Ingo Molnar wrote:
>>
>>> Commit-ID:  01ab31371da90a795b774d87edf2c21bb3a64dda
>>> Gitweb:     http://git.kernel.org/tip/01ab31371da90a795b774d87edf2c21bb3a64dda
>>> Author:     Siarhei Liakh <sliakh.lkml@gmail.com>
>>> AuthorDate: Sun, 31 Jan 2010 18:27:55 -0500
>>> Committer:  H. Peter Anvin <hpa@zytor.com>
>>> CommitDate: Wed, 17 Feb 2010 10:11:24 -0800
>>>
>>> x86, mm: NX protection for kernel data
>>>
>>> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
>>> (static) kernel data area as NX.
>>
>> -tip testing is seeing boot hangs along the lines of:
>>
>> [   15.568108] EXT3-fs (sda1): recovery complete
>> [   15.573064] EXT3-fs (sda1): mounted filesystem with ordered data mode
>> [   15.580313] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
>> [   15.584021] async_waiting @ 1
>> [   15.588008] async_continuing @ 1 after 0 usec
>> [   15.592163] Freeing unused kernel memory: 540k freed
>> [   15.600126] NX-protecting the kernel data: c15ab000, 2919 pages
>>
>> which i suspect could be due to the commit above.
> 
> Yep, that's confirmed now, applying these 3 reverts makes it boot fine:
> 
> 833e0ca: Revert "x86, mm: NX protection for kernel data"
> ce4b6b4: Revert "x86: RO/NX protection for loadable kernel modules"
> e357312: Revert "module: fix () used as prototype in include/linux/module.h"
> 

Given that e357312 is a () -> (void) prototype fix, is hardly seems
likely to be at fault.  The RO/NX stuff, on the other hand, make a lot
of sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

