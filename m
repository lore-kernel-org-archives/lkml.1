Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbYBZNkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbYBZNkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYBZNkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:40:19 -0500
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137]:33248 "HELO
	n20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753030AbYBZNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:40:16 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 08:40:16 EST
X-Yahoo-Newman-Id: 920904.43033.bm@omp413.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nGWl4Gzdtg0F8jJ09pEwsic3j0fMqcbRprC+vuetFuKEuYqAh415rSNzjCUiYJni58EdoXCDtgfn6+9rm2VxyzcZ/EISRtW/xg5nTmYP7M2YtiMrtNdVJEbKReP/vMhLGW4yH0k3GvYJ/6vWjW4qKpi9EeroAceCIW+ohvDMBPI=  ;
X-YMail-OSG: DzDXG.gVM1mJQ1mfhYb_nb_wqwCPSVeG3gK9ipyH7_kX.2ipvqgX1qPiQ0Xp4mLHTol4hIinvQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Otavio Salvador <otavio@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: oops when using git gc --auto
Date: Wed, 27 Feb 2008 00:33:31 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <87tzjvhmy7.fsf@ossystems.com.br>
In-Reply-To: <87tzjvhmy7.fsf@ossystems.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802270033.31297.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 00:22, Otavio Salvador wrote:
> Hello,
>
> Today I got this oops, someone has an idea of what's going wrong?
>
> Unable to handle kernel paging request at 0000020000000000 RIP:
>  [<ffffffff802735c3>] find_get_pages+0x3c/0x69

At this point, the most likely candidate is a memory corruption
error, probably hardware. Can you run memtest86 for a few hours
to get a bit more confidence in the hw (preferably overnight)?

I did recently see another quite similar corruption in the
pagecache radix-tree, though. Coincidence maybe?

> PGD 0
> Oops: 0000 [1] SMP
> CPU 3
> Modules linked in: sha256_generic aes_generic aes_x86_64 cbc blkcipher
> nvidia(P) rfcomm l2cap bluetooth ac battery ipv6 nfs lockd nfs_acl sunrpc
> bridge ext2 mbcache dm_crypt tun kvm_intel kvm loop snd_usb_audio
> snd_usb_lib snd_rawmidi snd_hda_intel e1000e i2c_i801 serio_raw
> snd_seq_device snd_pcm intel_agp button snd_timer pcspkr psmouse snd_hwdep
> snd snd_page_alloc soundcore evdev i2c_core xfs dm_mirror dm_snapshot
> dm_mod raid0 md_mod sg sr_mod cdrom sd_mod usbhid hid usb_storage
> pata_marvell floppy ahci ata_generic libata scsi_mod ehci_hcd uhci_hcd
> thermal processor fan Pid: 15684, comm: git Tainted: P       
> 2.6.24-1-amd64 #1
> RIP: 0010:[<ffffffff802735c3>]  [<ffffffff802735c3>]
> find_get_pages+0x3c/0x69 RSP: 0018:ffff8100394dfd98  EFLAGS: 00010097
> RAX: 0000000000000009 RBX: 000000000000000e RCX: 0000000000000009
> RDX: 0000020000000000 RSI: 000000000000000a RDI: 0000000000000040
> RBP: ffff810042964350 R08: 0000000000000040 R09: 000000000000000a
> R10: ffff8100425a06c8 R11: 000000000000000a R12: 000000000000000e
> R13: ffff8100394dfdf8 R14: ffff810042964350 R15: 0000000000000000
> FS:  00002ae326df2190(0000) GS:ffff81007d7aeb40(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000020000000000 CR3: 00000000358f9000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process git (pid: 15684, threadinfo ffff8100394de000, task
> ffff8100359cd800) Stack:  000000000000000d ffff8100394dfde8
> 000000000000000d 000000000000000e 000000000000000e ffffffff802794d6
> ffff8100014a7768 ffffffff80279b04 0000000000000000 ffffffffffffffff
> 0000000000000000 0000000000000000 Call Trace:
>  [<ffffffff802794d6>] pagevec_lookup+0x17/0x1e
>  [<ffffffff80279b04>] truncate_inode_pages_range+0x108/0x2bd
>  [<ffffffff802a9e3a>] generic_delete_inode+0xbf/0x127
>  [<ffffffff802a1a4d>] do_unlinkat+0xd5/0x144
>  [<ffffffff802989e2>] sys_write+0x45/0x6e
>  [<ffffffff8020be2e>] system_call+0x7e/0x83
>
>
> Code: 48 8b 02 25 00 40 02 00 48 3d 00 40 02 00 75 04 48 8b 52 10
> RIP  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
>  RSP <ffff8100394dfd98>
> CR2: 0000020000000000
> ---[ end trace cb43a9f4488b815a ]---

