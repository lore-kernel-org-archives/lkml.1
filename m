Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbXAWRqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbXAWRqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 12:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965260AbXAWRqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 12:46:11 -0500
Received: from mail.icabo.tv.br ([200.220.202.3]:41998 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965253AbXAWRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 12:46:10 -0500
Message-ID: <45B649BF.5030705@fliagreco.com.ar>
Date: Tue, 23 Jan 2007 14:45:35 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070122)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com> <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com> <459CFE7B.6090306@fliagreco.com.ar> <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com> <45A2376D.5060905@fliagreco.com.ar> <45A41E0E.9050608@fliagreco.com.ar> <45A4477E.6050703@gmail.com>
In-Reply-To: <45A4477E.6050703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Pablo.
>
> Please apply common hardware debugging method.  You know, swap drives.
> Use separate power supply for disks, swap cables, etc...
>
> It seems more like a hardware problem at this point.
>
> Thanks.
>
>   
Well, it took me a few days,  but I think I'm ready to report back. One 
of the drives was failing, and it stopped after rewiring power supply so 
the last problem seems to be corrected.
OTOH, your blacklist seems to be needed too, now I'm running FC6 
distribution kernel 2.6.19-1.2895.fc6 (2.6.19.2 + some patches by 
fedora) and setting
echo 1 >/sys/block/sdX/device/queue_depth
on all the SAMSUNG drives (sdb, sdc and sdd)
The second I type
echo 31 >/sys/block/sdX/device/queue_depth
on any of the drives I get these messages

Jan 23 12:36:30 squid kernel: BUG: warning: (ap->ops->error_handler && 
ata_tag_valid(ap->active_tag)) at 
drivers/ata/libata-core.c:4602/ata_qc_issue() (Not ta
inted)
Jan 23 12:36:30 squid kernel:
Jan 23 12:36:30 squid kernel: Call Trace:
Jan 23 12:36:30 squid kernel:  [<ffffffff8026999a>] show_trace+0x34/0x47
Jan 23 12:36:30 squid kernel:  [<ffffffff802699bf>] dump_stack+0x12/0x17
Jan 23 12:36:30 squid kernel:  [<ffffffff88092d50>] 
:libata:ata_qc_issue+0x61/0x551
Jan 23 12:36:30 squid kernel:  [<ffffffff88097bc8>] 
:libata:ata_scsi_translate+0xd1/0x11a
Jan 23 12:36:30 squid kernel:  [<ffffffff88098b87>] 
:libata:ata_scsi_queuecmd+0x103/0x122
Jan 23 12:36:30 squid kernel:  [<ffffffff8805cbc1>] 
:scsi_mod:scsi_dispatch_cmd+0x27c/0x30d
Jan 23 12:36:30 squid kernel:  [<ffffffff88061dbe>] 
:scsi_mod:scsi_request_fn+0x2ca/0x395
Jan 23 12:36:30 squid kernel:  [<ffffffff8033844e>] elv_insert+0x15a/0x226
Jan 23 12:36:30 squid kernel:  [<ffffffff8020bcc2>] 
__make_request+0x439/0x487
Jan 23 12:36:30 squid kernel:  [<ffffffff8021bf12>] 
generic_make_request+0x207/0x21e
Jan 23 12:36:30 squid kernel:  [<ffffffff80232f7d>] submit_bio+0xee/0xf7
Jan 23 12:36:30 squid kernel:  [<ffffffff8021a4f0>] submit_bh+0x130/0x150
Jan 23 12:36:30 squid kernel:  [<ffffffff80217187>] ll_rw_block+0x9d/0xc0
Jan 23 12:36:30 squid kernel:  [<ffffffff881adf63>] 
:reiserfs:search_by_key+0x13d/0xce7
Jan 23 12:36:30 squid kernel:  [<ffffffff881aee54>] 
:reiserfs:search_for_position_by_key+0x34/0x2ad
Jan 23 12:36:30 squid kernel:  [<ffffffff8819bd48>] 
:reiserfs:_get_block_create_0+0x86/0x544
Jan 23 12:36:30 squid kernel:  [<ffffffff8819d508>] 
:reiserfs:reiserfs_get_block+0xcd/0xfdd
Jan 23 12:36:30 squid kernel:  [<ffffffff80228c34>] 
do_mpage_readpage+0x16d/0x4b0
Jan 23 12:36:30 squid kernel:  [<ffffffff802388df>] 
mpage_readpages+0xb3/0x146
Jan 23 12:36:30 squid kernel:  [<ffffffff80212a81>] 
__do_page_cache_readahead+0x119/0x209
Jan 23 12:36:30 squid kernel:  [<ffffffff80231fed>] 
blockable_page_cache_readahead+0x56/0xb5
Jan 23 12:36:30 squid kernel:  [<ffffffff80213b7a>] 
page_cache_readahead+0xd6/0x1af
Jan 23 12:36:30 squid kernel:  [<ffffffff8020be39>] 
do_generic_mapping_read+0x129/0x40b
Jan 23 12:36:30 squid kernel:  [<ffffffff80216a02>] 
generic_file_aio_read+0x15f/0x1b1
Jan 23 12:36:30 squid kernel:  [<ffffffff8020c92b>] do_sync_read+0xc9/0x10c
Jan 23 12:36:30 squid kernel:  [<ffffffff8020b226>] vfs_read+0xcb/0x170
Jan 23 12:36:30 squid kernel:  [<ffffffff80211731>] sys_read+0x45/0x6e
Jan 23 12:36:30 squid kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
Jan 23 12:36:30 squid kernel:  [<000000359ccbfb80>]
Jan 23 12:36:30 squid kernel:

Thanks for everything.
Pablo.
