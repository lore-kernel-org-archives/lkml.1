Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbXJLMrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbXJLMrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760679AbXJLMqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:46:38 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:31565 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556AbXJLMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GpBqElhzWGn0KjdYvRQZ0kUxGXa7mrFrVqLSOsBWZk0RO+GwQMDVM9kL8BwsBhzX6RFVnM2Yt9zNL1bbXZvuk0zrca5oRDdL8X0zHVJj+zgBZgVjM6JOHLV/mD2HNZZJDzA6pwfxMzKdu94jgyLUTb1j+2T4To5cCZ1OoQKJsck=
Message-ID: <64bb37e0710120546s76b422fevabddd920506a3c96@mail.gmail.com>
Date: Fri, 12 Oct 2007 14:46:31 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-mm1
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20071012013729.ada2127b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <20071011234202.2f15bb76.akpm@linux-foundation.org>
	 <64bb37e0710120131y6b939951y74c50bd596b1d938@mail.gmail.com>
	 <20071012013729.ada2127b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 12 Oct 2007 10:31:42 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > But I did add the patch from http://lkml.org/lkml/2007/10/11/48 as my
> > personal hotfix.
>
> I think Jeff has that in hand?

I would more expect Jens, as the breakage in ata_sg_is_last comes
through the sglist patches from the block gittree.

That comment was more to say, that this patch does not blow up. ;)

> > Oct 12 10:23:03 treogen smartd[6091]: Device: /dev/sdc, not found in
> > smartd database.
>
> hm.

smartd always said that. Never thought that it would matter.
And it also say this about the other two identical drives that are
connected via the SiI 3132 instead the MCP55. And until now smartd
worked with this drive, logging temperature changes into
/var/log/messages.

hm: Even with the warnings below it does that:
Oct 12 10:53:25 treogen smartd[6095]: Device: /dev/sdc, SMART Usage
Attribute: 195 Hardware_ECC_Recovered changed from 57 to 58
Oct 12 11:23:26 treogen smartd[6095]: Device: /dev/sdc, SMART Usage
Attribute: 190 Temperature_Celsius changed from 51 to 50
Oct 12 11:23:26 treogen smartd[6095]: Device: /dev/sdc, SMART Usage
Attribute: 194 Temperature_Celsius changed from 49 to 50
Oct 12 13:23:25 treogen smartd[6095]: Device: /dev/sdc, SMART Usage
Attribute: 195 Hardware_ECC_Recovered changed from 58 to 57

But I have not seen any new WARNINGs...

Torsten

> > Oct 12 10:23:03 treogen [  105.990000] WARNING: at
> > drivers/ata/libata-core.c:5752 ata_qc_issue()
>
> Let's cc linux-ide.
>
> > Oct 12 10:23:03 treogen [  105.990000]
> > Oct 12 10:23:03 treogen [  105.990000] Call Trace:
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804442ef>]
> > ata_qc_issue+0x47f/0x540
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80449c80>]
> > ata_scsi_flush_xlat+0x0/0x30
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8044a6ea>]
> > ata_scsi_translate+0xfa/0x180
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8044d84d>]
> > ata_scsi_queuecmd+0x12d/0x210
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804333d0>]
> > scsi_dispatch_cmd+0x150/0x250
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804391f1>]
> > scsi_request_fn+0x1f1/0x360
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8039b827>]
> > elv_insert+0x167/0x250
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff803a0ac2>]
> > __make_request+0xe2/0x670
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8039d560>]
> > generic_make_request+0x1d0/0x3c0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff802bc1b9>]
> > bio_alloc_bioset+0xb9/0x140
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff802bc061>]
> > __bio_clone+0x91/0xc0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8039d7b6>]
> > submit_bio+0x66/0xf0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804cc06e>]
> > write_page+0x16e/0x2c0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80231b01>]
> > dequeue_task_fair+0x51/0xb0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804c482d>]
> > md_update_sb+0x18d/0x320
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804caa10>] md_thread+0x0/0x100
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804c9065>]
> > md_check_recovery+0x1f5/0x550
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804caa10>] md_thread+0x0/0x100
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804bf1d3>] raid5d+0x23/0x490
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8023eb12>]
> > try_to_del_timer_sync+0x52/0x60
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff805b0057>]
> > schedule_timeout+0x67/0xd0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8023e740>]
> > process_timeout+0x0/0x10
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff805b004a>]
> > schedule_timeout+0x5a/0xd0
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804caa10>] md_thread+0x0/0x100
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804caa40>]
> > md_thread+0x30/0x100
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8024a710>]
> > autoremove_wake_function+0x0/0x30
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804caa10>] md_thread+0x0/0x100
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
> > Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
> > Oct 12 10:23:03 treogen [  105.990000]
> > Oct 12 10:23:13 treogen [  115.940000] ata3.00: exception Emask 0x0
> > SAct 0x0 SErr 0x0 action 0x2 frozen
> > Oct 12 10:23:13 treogen [  115.940000] ata3.00: cmd
> > b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 0
> > Oct 12 10:23:13 treogen [  115.940000]          res
> > 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> > Oct 12 10:23:13 treogen [  115.940000] ata3.00: status: { DRDY }
> > Oct 12 10:23:14 treogen [  116.270000] ata3: soft resetting link
> > Oct 12 10:23:14 treogen [  116.430000] ata3: SATA link up 3.0 Gbps
> > (SStatus 123 SControl 300)
> > Oct 12 10:23:14 treogen [  116.740000] ata3.00: configured for UDMA/133
> > Oct 12 10:23:14 treogen [  116.740000] ata3: EH complete
> > Oct 12 10:23:14 treogen [  116.740000] WARNING: at
> > drivers/ata/libata-core.c:5752 ata_qc_issue()
> > Oct 12 10:23:14 treogen [  116.740000]
> > Oct 12 10:23:14 treogen [  116.740000] Call Trace:
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff804442ef>]
> > ata_qc_issue+0x47f/0x540
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80449c80>]
> > ata_scsi_flush_xlat+0x0/0x30
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8044a6ea>]
> > ata_scsi_translate+0xfa/0x180
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8044d84d>]
> > ata_scsi_queuecmd+0x12d/0x210
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff804333d0>]
> > scsi_dispatch_cmd+0x150/0x250
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff804391f1>]
> > scsi_request_fn+0x1f1/0x360
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80436b80>]
> > scsi_error_handler+0x0/0x310
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8039fe73>]
> > blk_run_queue+0x43/0x80
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80438659>]
> > scsi_run_host_queues+0x19/0x40
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80436d54>]
> > scsi_error_handler+0x1d4/0x310
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff80436b80>]
> > scsi_error_handler+0x0/0x310
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
> > Oct 12 10:23:14 treogen [  116.740000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
> > Oct 12 10:23:14 treogen [  116.740000]
> > Oct 12 10:23:14 treogen [  116.770000] sd 2:0:0:0: [sdc] 625142448
> > 512-byte hardware sectors (320073 MB)
> > Oct 12 10:23:14 treogen [  116.770000] sd 2:0:0:0: [sdc] Write Protect is off
> > Oct 12 10:23:14 treogen [  116.770000] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> > Oct 12 10:23:14 treogen [  116.770000] sd 2:0:0:0: [sdc] Write cache:
> > enabled, read cache: enabled, doesn't support DPO or FUA
> > Oct 12 10:23:24 treogen [  126.740000] ata3.00: exception Emask 0x0
> > SAct 0x0 SErr 0x0 action 0x2 frozen
> > Oct 12 10:23:24 treogen [  126.740000] ata3.00: cmd
> > b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 0
> > Oct 12 10:23:24 treogen [  126.740000]          res
> > 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> > Oct 12 10:23:24 treogen [  126.740000] ata3.00: status: { DRDY }
> > Oct 12 10:23:24 treogen [  127.070000] ata3: soft resetting link
> > Oct 12 10:23:25 treogen [  127.230000] ata3: SATA link up 3.0 Gbps
> > (SStatus 123 SControl 300)
> > Oct 12 10:23:25 treogen [  127.370000] ata3.00: configured for UDMA/133
> > Oct 12 10:23:25 treogen [  127.370000] ata3: EH complete
> > Oct 12 10:23:25 treogen [  127.370000] sd 2:0:0:0: [sdc] 625142448
> > 512-byte hardware sectors (320073 MB)
> > Oct 12 10:23:25 treogen [  127.370000] sd 2:0:0:0: [sdc] Write Protect is off
> > Oct 12 10:23:25 treogen [  127.370000] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> > Oct 12 10:23:25 treogen [  127.370000] sd 2:0:0:0: [sdc] Write cache:
> > enabled, read cache: enabled, doesn't support DPO or FUA
> > Oct 12 10:23:25 treogen smartd[6091]: Device: /dev/sdc, is SMART
> > capable. Adding to "monitor" list.
> > ... but I can still access the filesystem and the RAID device on that drive.
> > (sdc is MAXTOR STM332082 3.AA sata-drive on a MCP55 using sata_nv with
> > swncq activated)
> >
> > Torsten
>
