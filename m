Return-Path: <linux-kernel-owner+w=401wt.eu-S1763930AbXLTNlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763930AbXLTNlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763140AbXLTNiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:38:14 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:51231 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762918AbXLTNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=G4dUINb0sw/+FjBVjxTuCvCCpHMv9SqXW9Ykd46nYswf661bBkBCf1c2E3nN9qrxhqIKGRaY0u1cmrMqb/z9jVZopJMSUxj4TylNmH70aXTglxo8dPvQ0rZBgMz2rqZGvoX1/PcvapXHGNkmHc9USczfyPUIBT+fWeLpwq1TWpM=
Message-ID: <476A703B.50804@gmail.com>
Date: Thu, 20 Dec 2007 08:38:03 -0500
From: Miles Lane <miles.lane@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70  --  (triggered
 by "cat /proc/iomem" AFTER suspend-to-disk/resume)
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com> <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com>
In-Reply-To: <4769FF37.5060308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On further investigation, "cat /proc/iomem" does not trigger the stack 
trace until after a suspend-to-disk/resume cycle has occurred.

I am removing Ingo and Russell from the TO list (as they are apparently 
the wrong people) and adding the suspend folks, as suspend is implicated.
My .config file can be found here:  
http://marc.info/?l=linux-kernel&m=119812903001296&w=2

Miles Lane wrote:
> .config attached in order to not trip spam filters.
>
> Miles Lane wrote:
>> [  252.868386] BUG: unable to handle kernel NULL pointer dereference 
>> at virtual address 00000018
>> [  252.868393] printing ip: c012d527 *pde = 00000000
>> [  252.868399] Oops: 0000 [#1] SMP
>> [  252.868403] last sysfs file: 
>> /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/stat 
>>
>> [  252.868407] Modules linked in: aes_i586 aes_generic i915 drm 
>> rfcomm l2cap bluetooth acpi_cpufreq cpufreq_stats 
>> cpufreq_conservative sbs sbshc dm_crypt sbp2 parport_pc lp parport 
>> arc4 ecb crypto_blkcipher cryptomgr crypto_algapi snd_hda_intel 
>> snd_pcm_oss snd_mixer_oss pcmcia snd_pcm iTCO_wdt iTCO_vendor_support 
>> snd_seq_dummy watchdog_core watchdog_dev snd_seq_oss snd_seq_midi 
>> tifm_7xx1 snd_rawmidi iwl3945 snd_seq_midi_event rng_core tifm_core 
>> mac80211 snd_seq snd_timer snd_seq_device cfg80211 sky2 battery 
>> yenta_socket rsrc_nonstatic pcmcia_core ac snd soundcore 
>> snd_page_alloc button shpchp pci_hotplug sr_mod cdrom pata_acpi piix 
>> ide_core firewire_ohci firewire_core crc_itu_t thermal processor fan
>> [  252.868469]
>> [  252.868472] Pid: 7088, comm: head Not tainted (2.6.24-rc5-mm1 #9)
>> [  252.868476] EIP: 0060:[<c012d527>] EFLAGS: 00010297 CPU: 0
>> [  252.868481] EIP is at r_show+0x2a/0x70
>> [  252.868483] EAX: 00000000 EBX: 00000001 ECX: c07e3224 EDX: c04bb034
>> [  252.868486] ESI: 00000008 EDI: ed1f52c0 EBP: f5320f10 ESP: f5320f04
>> [  252.868489]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [  252.868493] Process head (pid: 7088, ti=f5320000 task=f532e000 
>> task.ti=f5320000)
>> [  252.868495] Stack: c03a6cac ed1f52c0 c07e3224 f5320f50 c0199a7e 
>> 00002000 bf930807 e1007800
>> [  252.868504]        ed1f52e0 00000000 00000000 000001d3 0000000e 
>> 00000000 0000000d 00000000
>> [  252.868512]        fffffffb f7d39370 c01998e4 f5320f74 c01af4f5 
>> f5320f9c 00002000 bf930807
>> [  252.868521] Call Trace:
>> [  252.868523]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
>> [  252.868529]  [<c0107df2>] show_stack_log_lvl+0x8a/0x95
>> [  252.868534]  [<c0107e89>] show_registers+0x8c/0x154
>> [  252.868538]  [<c010805f>] die+0x10e/0x1d2
>> [  252.868542]  [<c039c8c9>] do_page_fault+0x52b/0x600
>> [  252.868547]  [<c039af9a>] error_code+0x72/0x78
>> [  252.868552]  [<c0199a7e>] seq_read+0x19a/0x26c
>> [  252.868557]  [<c01af4f5>] proc_reg_read+0x60/0x74
>> [  252.868562]  [<c018390d>] vfs_read+0xa2/0x11e
>> [  252.868567]  [<c0183d02>] sys_read+0x3b/0x60
>> [  252.868571]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
>> [  252.868575]  =======================
>> [  252.868577] Code: c3 55 89 d1 89 e5 57 89 c7 56 53 8b 50 64 83 7a 
>> 0c 00 77 0e 81 7a 08 ff ff 00 00 be 04 00 00 00 76 05 be 08 00 00 00 
>> 89 c8 31 db <8b> 40 18 39 d0 74 06 43 83 fb 05 75 f3 8b 41 10 ba 2f 
>> 1b 45 c0
>> [  252.868623] EIP: [<c012d527>] r_show+0x2a/0x70 SS:ESP 0068:f5320f04
