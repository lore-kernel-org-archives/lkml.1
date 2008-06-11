Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYFKKxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYFKKxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYFKKw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:52:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:36838 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYFKKwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ac+skZHkKTtDfsyk17iMMHHt10xRHvF9P3YrAjpN6i2kjMzoJZxrh6dp64IrmX4Vvu
         Df1XmXncHqvJq4SqP99ZI0RKr9fZtkZv7M+qAUJcT41ObkDJq2Dif5jG4pMxbyF79hmM
         y4V0MCGZnE3+qkeILFYVJsQMDlFrWOLLpQezA=
Message-ID: <19f34abd0806110352s53628c2bi634028b954ee6cde@mail.gmail.com>
Date: Wed, 11 Jun 2008 12:52:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Walter Franzini" <walter.franzini@gmail.com>
Subject: Re: Oops: 0000 [#1] PREEMPT SMP
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>
In-Reply-To: <863ank6zmd.fsf@acer.nord-com.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <863ank6zmd.fsf@acer.nord-com.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/11/08, Walter Franzini <walter.franzini@gmail.com> wrote:
> With 2.6.25.6 I've got the following oops while running aegis.

Thanks for reporting.

>  ------------------------------------------------------------------------
>  Oops: 0000 [#1] PREEMPT SMP

Is this the first line of the report that you have? Looks like there
could be more useful information just before this.

>  Modules linked in: appletalk ipx p8023 cpufreq_ondemand xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables tun ppdev lp fuse sbp2 acpi_cpufreq freq_table joydev arc4 ecb crypto_blkcipher pcmcia snd_hda_intel iwl3945 snd_pcm_oss snd_mixer_oss snd_pcm firmware_class iTCO_wdt mac80211 yenta_socket pcspkr snd_timer container rsrc_nonstatic pcmcia_core serio_raw cfg80211 i2c_i801 bay ac wmi i2c_core irda snd battery soundcore snd_page_alloc psmouse button evdev intel_agp agpgart sg crc_ccitt parport_pc parport sr_mod cdrom rtc ext3 jbd mbcache dm_mirror dm_snapshot dm_mod sd_mod usbhid hid ata_piix ohci1394 ieee1394 ata_generic libata ehci_hcd uhci_hcd scsi_mod usbcore e1000 dock thermal processor fan
>
>  Pid: 20443, comm: aegis Not tainted (2.6.25.6-0 #1)
>  EIP: 0060:[<c014d949>] EFLAGS: 00210016 CPU: 1
>  EIP is at get_page_from_freelist+0x171/0x397
>  EAX: c033560c EBX: 001200d2 ECX: 7c30302e EDX: 00000002
>  ESI: c0335600 EDI: 00200202 EBP: 7c303016 ESP: f48e9ce8
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  Process aegis (pid: 20443, ti=f48e8000 task=f4871640 task.ti=f48e8000)
>  Stack: c3c85e28 00000002 00000000 001200d2 c0336050 c0335580 00000002 00000000
>        00000000 00200292 001200d2 001200d2 c0336048 00000000 c014dcef 00000044
>        001200d2 00000010 f7106e10 f4871640 00001000 c033604c c02a582c 001200d2
>  Call Trace:
>   [<c014dcef>] __alloc_pages+0x5f/0x2b4
>   [<c02a582c>] _read_unlock_irq+0xe/0x21
>   [<c014987b>] __grab_cache_page+0x56/0x86
>   [<f89d2932>] ext3_write_begin+0x51/0x16d [ext3]
>   [<c014a253>] generic_file_buffered_write+0xf8/0x56f
>   [<c011590f>] update_curr+0x3d/0x52
>   [<c014ab1a>] __generic_file_aio_write_nolock+0x450/0x4b2
>   [<c0149326>] file_read_actor+0x7d/0xcc
>   [<c014abce>] generic_file_aio_write+0x52/0xa9
>   [<f89cf1d1>] ext3_file_write+0x19/0x83 [ext3]
>   [<c0164194>] do_sync_write+0xbf/0x100
>   [<c012e3c0>] autoremove_wake_function+0x0/0x2d
>   [<c0134c0a>] clockevents_program_event+0xc4/0xd2
>   [<c02a5555>] _spin_lock_irq+0xe/0x24
>   [<c01a7adc>] security_file_permission+0xc/0xd
>   [<c01640d5>] do_sync_write+0x0/0x100
>   [<c016489b>] vfs_write+0x83/0xf6
>   [<c0164dd1>] sys_write+0x3c/0x63
>   [<c01047ae>] sysenter_past_esp+0x5f/0x85
>   =======================
>  Code: 3b 8d 69 e8 8b 4d 1c 0f 18 01 90 8d 55 18 8d 46 0c 39 c2 75 e3 eb 25 8b 6e 0c 83 ed 18 eb 0c 8b 54 24 18 39 55 0c 74 14 8d 69 e8 <8b> 4d 18 0f 18 01 90 8d 55 18 8d 46 0c 39 c2 75 e3 8d 55 18 8d
>  EIP: [<c014d949>] get_page_from_freelist+0x171/0x397 SS:ESP 0068:f48e9ce8
>  ---[ end trace abef59c84226d498 ]---
>  note: aegis[20443] exited with preempt_count 1
>  ------------------------------------------------------------------------

For me, this is:

$ addr2line -e mm/page_alloc.o -i 1a37
mm/page_alloc.c:1078
mm/page_alloc.c:1436

(sources are v2.6.25.6.)

The first line is in function buffered_rmqueue (inlined by gcc):
        list_for_each_entry_reverse(page, &pcp->list, lru)

Last modified in

commit 3dfa5721f12c3d5a441448086bee156887daa961
Author: Christoph Lameter <clameter@sgi.com>
Date:   Mon Feb 4 22:29:19 2008 -0800

    Page allocator: get rid of the list of cold pages

I'm also seeing an LRU-related commit that looks very interesting:

commit 06c9630008899ee40df90c5ff248c2165fda54fd
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Thu May 15 02:45:16 2008 +0000

It has, for example, this text, which seems highly relevant here:

    in __free_one_page() tries to do a list_add to something that isn't even
    necessarily a list.

Adding to Cc.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
