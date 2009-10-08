Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZJHALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZJHALT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 20:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZJHALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 20:11:19 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:47050 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZJHALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 20:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=SyIU3sAnUAphbijaLtlNArHSIA9hiZluQMgJxTRW/Yiqx3gXlzhzZ24IVLJdgfFda6
         17p60gG9GZFAKYTnMbcG1U9dhdKxr67pujSzbZ2MoFtk1xhrB+1ysEknvCJr1Eqdf++q
         kqA2vNUinPDAtl6UbMg1eZFwnHbcX22rnXOe0=
MIME-Version: 1.0
In-Reply-To: <6dd519ae0910071634q329239f2n360c8a54fcb81a26@mail.gmail.com>
References: <6dd519ae0910071634q329239f2n360c8a54fcb81a26@mail.gmail.com>
Date: Thu, 8 Oct 2009 03:10:41 +0300
Message-ID: <6dd519ae0910071710q6d4acealb749966a86fb860b@mail.gmail.com>
Subject: Re: BUG: bad page state in process (In version 2.6.31.2)
From: Brian Marete <bgmarete@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 2:34 AM, Brian Marete <bgmarete@gmail.com> wrote:
> Hello,
>
> Just found the BUG back-trace pasted below in my kernel logs.

Sorry, failed to post the 1st two lines of the BUG trace. So, here is
the entire trace once more:

[  508.575356] BUG: Bad page state in process tracker-indexer  pfn:64e71
[  508.575370] page:c459de20 flags:80000000 count:0 mapcount:0
mapping:00000001 index:0
[  508.575381] Pid: 3827, comm: tracker-indexer Tainted: P           2.6.31.2 #1
[  508.575387] Call Trace:
[  508.575402]  [<c055f750>] ? printk+0x18/0x20
[  508.575414]  [<c01b28a4>] bad_page+0xc4/0x130
[  508.575424]  [<c01b32af>] get_page_from_freelist+0x37f/0x490
[  508.575435]  [<c01b36bd>] __alloc_pages_nodemask+0xcd/0x540
[  508.575446]  [<c012da80>] ? __wake_up+0x40/0x50
[  508.575455]  [<c01b6462>] __do_page_cache_readahead+0xd2/0x1d0
[  508.575464]  [<c01b6588>] ra_submit+0x28/0x40
[  508.575472]  [<c01b66ff>] ondemand_readahead+0x7f/0x1f0
[  508.575481]  [<c01283ba>] ? kunmap_atomic+0x6a/0x90
[  508.575489]  [<c01b68e8>] page_cache_async_readahead+0x78/0x90
[  508.575499]  [<c01af566>] generic_file_aio_read+0x386/0x6a0
[  508.575508]  [<c01f912a>] ? mntput_no_expire+0x1a/0xd0
[  508.575518]  [<c01e2361>] do_sync_read+0xd1/0x110
[  508.575529]  [<c0157160>] ? autoremove_wake_function+0x0/0x50
[  508.575538]  [<c01f912a>] ? mntput_no_expire+0x1a/0xd0
[  508.575548]  [<c02c414f>] ? security_file_permission+0xf/0x20
[  508.575556]  [<c01e23f4>] ? rw_verify_area+0x54/0xd0
[  508.575564]  [<c01e3c85>] ? __fput+0x175/0x1f0
[  508.575572]  [<c01e2b49>] vfs_read+0x99/0x190
[  508.575580]  [<c01e2290>] ? do_sync_read+0x0/0x110
[  508.575588]  [<c01e2cfd>] sys_read+0x3d/0x70
[  508.575597]  [<c010301c>] sysenter_do_call+0x12/0x28



-- 
B. Gitonga Marete
Tel: +254-722-151-590
