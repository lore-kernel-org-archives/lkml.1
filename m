Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXBNDxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXBNDxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 22:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXBNDxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 22:53:11 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30814 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751147AbXBNDxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 22:53:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=tXRc9gDXQ1+fjniPInwKAZBlufg+8LYS2g6NnYntt8PPqC0eEhzwoQcWq9fBbCtR09lplCjydD474wHHE/074GzO99lwq2fH6hwLadkaU3YKekrHYpvs4x5Z+gR0IKa/PEDM6uYIzdqy5Wtv2Zg9fsoovMst1PU2r5TNhwt6V+g=  ;
X-YMail-OSG: cmvzZ6gVM1k0fJYNNbngDtcOhUkElD9vklrpkaaqS8Wa5sF.2cmrI_9wJiILRmntdJUUP_pPu8w15b6TSpuX8HAbbQf0EXMVJfZMgE.TnXZiwVcyc3tyZGo5m_X5LeasCrrn9BLwhddRDuc-
Message-ID: <45D2878E.1020603@yahoo.com.au>
Date: Wed, 14 Feb 2007 14:52:46 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Help! How do I debug oopsing kernel workqueue threads?
References: <45D259C3.6070109@redhat.com>
In-Reply-To: <45D259C3.6070109@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> How the hell do I tell what kernel subsystem queued
> a bogus work item?

Can you add a new field to struct list_head and add the caller's
address in there?

> 
> BUG: unable to handle kernel paging request at virtual address 00002074
>  printing eip:
> c04f3b55
> *pde = 71bb1067
> Oops: 0000 [#1]
> SMP
> last sysfs file: /class/scsi_host/host2/proc_name
> Modules linked in: hwmon i2c_isa eeprom sunrpc ipv6 ip_nat_sip ip_nat_pptp 
> ip_nat_ftp ip_conntrack_sip ip_conntrack_pptp ip_conntrack_ftp xt_helper ipt_LOG 
> xt_state xt_tcpudp iptable_mangle iptable_nat ip_nat ip_conntrack nfnetlink 
> iptable_filter ip_tables x_tables dm_mirror dm_multipath dm_mod video sbs i2c_ec 
> button battery asus_acpi ac lp snd_hda_intel snd_hda_codec snd_seq_dummy 
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss 
> sg snd_pcm snd_timer ide_cd floppy snd serio_raw cdrom sky2 ohci1394 ieee1394 
> soundcore pcspkr iTCO_wdt skge i2c_i801 snd_page_alloc i2c_core parport_pc 
> parport ata_piix libata aacraid sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd 
> uhci_hcd
> CPU:    0
> EIP:    0060:[<c04f3b55>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.19-1.2895.fc6 #1)
> EIP is at list_del+0x2d/0x6c
> eax: 00002070   ebx: f76f0f80   ecx: 00000001   edx: 00000000
> esi: f7ff8dc0   edi: d6ca8000   ebp: f7e6f380   esp: f7fefef0
> ds: 007b   es: 007b   ss: 0068
> Process events/0 (pid: 8, ti=f7fef000 task=f7e205d0 task.ti=f7fef000)
> Stack: f7e205d0 d7ade040 f7ff8d40 f76f0f80 c04717fc f703e0c0 c07a2fc8 f703e0c0
>        00000001 00000000 f7ff8e60 f7ff8e60 00000001 f7ff8e40 00000000 c04718ff
>        00000000 00000000 f7e6f380 f7ff8de4 f7ff8dc0 f7e6f380 f7e0bac0 00000282
> Call Trace:
>  [<c04717fc>] free_block+0x77/0xf0
>  [<c04718ff>] drain_array+0x8a/0xb5
>  [<c0472e9c>] cache_reap+0x53/0x117
>  [<c04368c7>] run_workqueue+0x97/0xdd
>  [<c0437284>] worker_thread+0xd9/0x10d
>  [<c0439810>] kthread+0xc0/0xec
>  [<c0404c03>] kernel_thread_helper+0x7/0x10
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
