Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXEPMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXEPMr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbXEPMrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:47:48 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43775 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760304AbXEPMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:47:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=nO/cViuCDZBDVxxl7uSyKtOMyU/c8F5hREYG0+R/jefUP5u6soP1xqctcajYzJMZX3uucuT+03EBl75p1ql49dnsWARLlNDC2jlOm1aXhnUSaa+X3UnxQDjqI1CqlByrirEbD730/Z3RksK6+CBqXS1qt8PGvmFoA+rI4b3a4Zs=  ;
X-YMail-OSG: qvmcrHkVM1mpjMqDXb_b819F5Zzt5jwYcJvvSsZ1oByJx4.mukrETVQXG6XN3fOCupvEsiDrbp6N1Q5JZoM0yE4m6GN.sIAaEYxHoZwpKKle.iEPgKb5CBqCuzznpw--
Message-ID: <464AFD6D.4000103@yahoo.com.au>
Date: Wed, 16 May 2007 22:47:41 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464AF4A6.5060000@gmail.com> <464AFB81.5050109@yahoo.com.au> <464AFCC6.5030208@gmail.com>
In-Reply-To: <464AFCC6.5030208@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060001010401020003080106"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001010401020003080106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jiri Slaby wrote:
> Nick Piggin napsal(a):
> 
>>Jiri Slaby wrote:
>>
>>>Andrew Morton napsal(a):
>>>
>>>
>>>>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>>>
>>>
>>>
>>>I've got this in dmesg:
>>>
>>>BUG: at /local/xslaby/xxx/mm/page-writeback.c:829
>>>__set_page_dirty_nobuffers()
>>> [<c010531e>] dump_trace+0x1ce/0x200
>>> [<c010536a>] show_trace_log_lvl+0x1a/0x30
>>> [<c0106012>] show_trace+0x12/0x20
>>> [<c0106086>] dump_stack+0x16/0x20
>>> [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>>> [<c0155690>] redirty_page_for_writepage+0x10/0x20
>>> [<c01938fc>] __block_write_full_page+0x20c/0x330
>>> [<c0193b0a>] block_write_full_page+0xea/0x100
>>> [<c0196c82>] blkdev_writepage+0x12/0x20
>>> [<c015539e>] __writepage+0xe/0x30
>>> [<c01558c2>] write_cache_pages+0x222/0x340
>>> [<c0155a03>] generic_writepages+0x23/0x30
>>> [<c0155a3e>] do_writepages+0x2e/0x50
>>> [<c018decb>] __writeback_single_inode+0x8b/0x470
>>> [<c018e75b>] generic_sync_sb_inodes+0x24b/0x470
>>> [<c018e9a7>] sync_sb_inodes+0x27/0x30
>>> [<c018ec33>] writeback_inodes+0xb3/0xe0
>>> [<c01560f2>] wb_kupdate+0x82/0xf0
>>> [<c015660b>] pdflush+0xeb/0x1b0
>>> [<c0132e72>] kthread+0x42/0x70
>>> [<c0104d4b>] kernel_thread_helper+0x7/0x1c
>>
>>Do you have any messages before this one? Seems like it is probably
>>metadata,
>>but we've only caught it at the last minute...
> 
> 
> No other messages before that. Bazillion through-nfs stacks after this...

Does this patch fix NFS?

-- 
SUSE Labs, Novell Inc.

--------------060001010401020003080106
Content-Type: text/plain;
 name="nfs-invariant-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfs-invariant-fix.patch"

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -826,7 +826,7 @@ int __set_page_dirty_nobuffers(struct pa
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
-			WARN_ON(!PageUptodate(page));
+			WARN_ON(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				task_io_account_write(PAGE_CACHE_SIZE);

--------------060001010401020003080106--
