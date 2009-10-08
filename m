Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZJHBFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZJHBFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZJHBFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:05:40 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39776 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZJHBFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=eDxoMHwo4bKf4/IriS2ZpKo5n4LBRLsScFuECQs2lVC4enFfgxtxdbrnTj9boiB3AB
         HhcIFZomZVjn5b0OPq3crzxo4QqcEU7od4ILult/0KAoLQcu+0Jyy6HIV4aMdX86c3YE
         GiopWwgFlMzCin6EzOY1Ar7tjUzO5HcyByiG0=
MIME-Version: 1.0
In-Reply-To: <6dd519ae0910071710q6d4acealb749966a86fb860b@mail.gmail.com>
References: <6dd519ae0910071634q329239f2n360c8a54fcb81a26@mail.gmail.com>
	 <6dd519ae0910071710q6d4acealb749966a86fb860b@mail.gmail.com>
Date: Thu, 8 Oct 2009 04:05:02 +0300
Message-ID: <6dd519ae0910071805y6000f563y422c42f43bc5e6a2@mail.gmail.com>
Subject: Re: BUG: bad page state in process (In version 2.6.31.2)
From: Brian Marete <bgmarete@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 3:10 AM, Brian Marete <bgmarete@gmail.com> wrote:
> On Thu, Oct 8, 2009 at 2:34 AM, Brian Marete <bgmarete@gmail.com> wrote:
>> Hello,
>>
>> Just found the BUG back-trace pasted below in my kernel logs.

Rebooted the machine and the same BUG manifests. See the trace below:

(Also, run memtest86 just in case I have bad memory.)

[  726.890990] BUG: Bad page state in process tracker-indexer  pfn:77541
[  726.890997] page:c47eb820 flags:80000000 count:0 mapcount:0
mapping:00000001 index:0
[  726.891002] Pid: 9758, comm: tracker-indexer Tainted: P           2.6.31.2 #1
[  726.891005] Call Trace:
[  726.891014]  [<c055f750>] ? printk+0x18/0x20
[  726.891021]  [<c01b28a4>] bad_page+0xc4/0x130
[  726.891025]  [<c01b32af>] get_page_from_freelist+0x37f/0x490
[  726.891030]  [<c01b36bd>] __alloc_pages_nodemask+0xcd/0x540
[  726.891036]  [<c013a3f7>] ? update_curr+0x217/0x220
[  726.891040]  [<c01b6462>] __do_page_cache_readahead+0xd2/0x1d0
[  726.891044]  [<c01b6588>] ra_submit+0x28/0x40
[  726.891047]  [<c01b66ff>] ondemand_readahead+0x7f/0x1f0
[  726.891051]  [<c01b68e8>] page_cache_async_readahead+0x78/0x90
[  726.891055]  [<c01af566>] generic_file_aio_read+0x386/0x6a0
[  726.891061]  [<c01e2361>] do_sync_read+0xd1/0x110
[  726.891066]  [<c0157160>] ? autoremove_wake_function+0x0/0x50
[  726.891072]  [<c02c414f>] ? security_file_permission+0xf/0x20
[  726.891075]  [<c01e23f4>] ? rw_verify_area+0x54/0xd0
[  726.891079]  [<c01e2b49>] vfs_read+0x99/0x190
[  726.891082]  [<c01e2290>] ? do_sync_read+0x0/0x110
[  726.891086]  [<c01e2cfd>] sys_read+0x3d/0x70
[  726.891089]  [<c010301c>] sysenter_do_call+0x12/0x28


-- 
B. Gitonga Marete
Tel: +254-722-151-590
