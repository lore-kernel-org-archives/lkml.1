Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZFTP2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZFTP2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTP16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:27:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36728 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZFTP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rUC4LVM05eCZQHRwulnu8ruMc+4Nel6f+vcIAE36qyW55RU1d8Ot+DgBdfzNqeC/ZN
         KHaQGfon0nhOBCt7/EA5vGEKSIRUKpWRy2t2h2cMMng8seGjZiqc/8dedUQ8gBGZJ742
         tmd0TA4Xbr4HHZUNtpVAugVFnwWApKnmBKjz0=
Message-ID: <4A3CFFEC.1000805@gmail.com>
Date: Sat, 20 Jun 2009 17:27:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: BUG: Bad page state [was: Strange oopses in 2.6.30]
References: <1245448091.5475.19.camel@localhost> <1245506908.6327.36.camel@localhost>
In-Reply-To: <1245506908.6327.36.camel@localhost>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2009 04:08 PM, Maxim Levitsky wrote:
> On Sat, 2009-06-20 at 00:48 +0300, Maxim Levitsky wrote:
>> I see lots of following oopses in 2.6.30 and latest -git 
>>
>> Many different applications shows up, not just reiserfsck
>> Something in MM I guess, it makes me worry. But system seems to work.
>>
>> Is this known?
>>
>> dmesg attached.
>>
>>
>> [   34.544040] BUG: Bad page state in process reiserfsck  pfn:37d86
>> [   34.544044] page:c2a34f38 flags:3650000c count:0 mapcount:0
>> mapping:(null) index:bffeb
>> [   34.544048] Pid: 2654, comm: reiserfsck Tainted: G    B
>> 2.6.30-git #4
>> [   34.544051] Call Trace:
>> [   34.544055]  [<c04cd26a>] ? printk+0x18/0x1e
>> [   34.544059]  [<c018f065>] bad_page+0xd5/0x140
>> [   34.544064]  [<c0190097>] free_hot_cold_page+0x1e7/0x280
>> [   34.544069]  [<c0193682>] ? release_pages+0x92/0x1b0
>> [   34.544074]  [<c0190155>] __pagevec_free+0x25/0x30
>> [   34.544078]  [<c0193758>] release_pages+0x168/0x1b0
>> [   34.544084]  [<c0193cf3>] ? lru_add_drain+0x53/0xd0
>> [   34.544088]  [<c01ab7d4>] free_pages_and_swap_cache+0x84/0xa0
>> [   34.544093]  [<c019ff5d>] unmap_vmas+0x73d/0x760
>> [   34.544099]  [<c016480e>] ? lock_release_non_nested+0x15e/0x270
>> [   34.544104]  [<c01a43b5>] exit_mmap+0xb5/0x1b0
>> [   34.544109]  [<c0138666>] mmput+0x36/0xc0
>> [   34.544113]  [<c013c874>] exit_mm+0xe4/0x120
>> [   34.544117]  [<c0175539>] ? acct_collect+0x139/0x180
>> [   34.544122]  [<c013e889>] do_exit+0x6b9/0x720
>> [   34.544142]  [<c01bcac2>] ? vfs_write+0x122/0x180
>> [   34.544146]  [<c01bbda0>] ? do_sync_write+0x0/0x110
>> [   34.544151]  [<c013e920>] do_group_exit+0x30/0x90
>> [   34.544156]  [<c013e993>] sys_exit_group+0x13/0x20
>> [   34.544161]  [<c01039e8>] sysenter_do_call+0x12/0x3c
>> [   34.544180] BUG: Bad page state in process reiserfsck  pfn:37d91
>> [   34.544184] page:c2a35174 flags:3650000c count:0 mapcount:0
>> mapping:(null) index:bfff6
>> [   34.544188] Pid: 2654, comm: reiserfsck Tainted: G    B
>> 2.6.30-git #4

I got similar on 64-bit mmotm 2009-06-12-12-20. You seem not to use
2.6.30, but some git post 2.6.30.

Flags are:
0000000000400000 -- __PG_MLOCKED
800000000050000c -- my page flags
        3650000c -- Maxim's page flags
0000000000693ce1 -- my PAGE_FLAGS_CHECK_AT_FREE

In my .config, there is
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y

The traces:
BUG: Bad page state in process gpg-agent  pfn:1c83c9
page:ffffea00063cd3f8 flags:800000000050000c count:0 mapcount:0
mapping:(null) i
ndex:7feda9eae
Pid: 3859, comm: gpg-agent Not tainted 2.6.30-mm1_64 #641
Call Trace:
 [<ffffffff8108fab2>] bad_page+0xd2/0x130
 [<ffffffff81091a57>] free_hot_cold_page+0x47/0x200
 [<ffffffff81091c48>] __pagevec_free+0x38/0x50
 [<ffffffff81094eac>] release_pages+0x20c/0x240
 [<ffffffff810afc6f>] free_pages_and_swap_cache+0xaf/0xd0
 [<ffffffff8115d53a>] ? cpumask_any_but+0x2a/0x40
 [<ffffffff810a8520>] unmap_region+0x150/0x170
 [<ffffffff810a87b4>] do_munmap+0x274/0x370
 [<ffffffff810a88fc>] sys_munmap+0x4c/0x70
 [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
Disabling lock debugging due to kernel taint
BUG: Bad page state in process gpg-agent  pfn:1c83c8
page:ffffea00063cd3c0 flags:800000000050000c count:0 mapcount:0
mapping:(null) i
ndex:7feda9ead
Pid: 3859, comm: gpg-agent Tainted: G    B      2.6.30-mm1_64 #641
Call Trace:
 [<ffffffff8108fab2>] bad_page+0xd2/0x130
 [<ffffffff81091a57>] free_hot_cold_page+0x47/0x200
 [<ffffffff81091c48>] __pagevec_free+0x38/0x50
 [<ffffffff81094eac>] release_pages+0x20c/0x240
 [<ffffffff810afc6f>] free_pages_and_swap_cache+0xaf/0xd0
 [<ffffffff8115d53a>] ? cpumask_any_but+0x2a/0x40
 [<ffffffff810a8520>] unmap_region+0x150/0x170
 [<ffffffff810a87b4>] do_munmap+0x274/0x370
 [<ffffffff810a88fc>] sys_munmap+0x4c/0x70
 [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
BUG: Bad page state in process gpg-agent  pfn:1c800f
page:ffffea00063c0348 flags:800000000050000c count:0 mapcount:0
mapping:(null) i
ndex:7feda9eac
Pid: 3859, comm: gpg-agent Tainted: G    B      2.6.30-mm1_64 #641
Call Trace:
 [<ffffffff8108fab2>] bad_page+0xd2/0x130
 [<ffffffff81091a57>] free_hot_cold_page+0x47/0x200
 [<ffffffff81091c48>] __pagevec_free+0x38/0x50
 [<ffffffff81094eac>] release_pages+0x20c/0x240
 [<ffffffff810afc6f>] free_pages_and_swap_cache+0xaf/0xd0
 [<ffffffff8115d53a>] ? cpumask_any_but+0x2a/0x40
 [<ffffffff810a8520>] unmap_region+0x150/0x170
 [<ffffffff810a87b4>] do_munmap+0x274/0x370
 [<ffffffff810a88fc>] sys_munmap+0x4c/0x70
 [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
