Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYI2Bip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYI2Bip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 21:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYI2Bih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 21:38:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:3112 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYI2Bih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 21:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=O0ANTpqJn4W4uN89YjwgbqoBNMK53oHvndSEQZNL6tV8bLYMVLGyggVnPgtBLXK/ui
         eQNfY0EqKnD0x2GzXXgul6bdb9tZHO9W+Lyob/6obqY858fIyGGPYp1REHJAp3ytNKku
         0Pma+dneH5YNs3fNV9owKgjbhrsNwNKo+J3sA=
Message-ID: <48E0311F.2030907@gmail.com>
Date: Mon, 29 Sep 2008 10:36:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>
CC: Todor Gyumyushev <todor@saturnosoft.biz>,
       Jens Axboe <jens.axboe@oracle.com>, Albert Lee <albertcc@tw.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: bug report
References: <48DA0B39.5050401@saturnosoft.biz>	 <1222274317.14959.4.camel@odie.local>  <48DA7F1E.5030508@saturnosoft.biz> <1222280712.14959.14.camel@odie.local>
In-Reply-To: <1222280712.14959.14.camel@odie.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Holm Thøgersen wrote:
> [ CC'ing linux-ide mailing list and the people involved in commit
>   56c819df (libata: update ATAPI overflow draining) that introduced the
>   WARN_ON. ]
> 
> ons, 24 09 2008 kl. 20:55 +0300, skrev Todor Gyumyushev:
>> Simon Holm Thøgersen wrote:
>>> ons, 24 09 2008 kl. 12:41 +0300, skrev Todor Gyumyushev:
>>>   
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/ata/libata-sff.c:944 ata_sff_hsm_move+0x4a9/0x6a0()
>>>> Modules linked in: cdc_acm eth1394 vboxdrv isofs zlib_inflate ath5k 
>>>> aes_generic nls_utf8 nls_cp437 vfat fat nls_base i915 drm kvm 
>>>> acpi_cpufreq hci_usb rfcomm l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss 
>>>> sunrpc exportfs fan ac battery microcode firmware_class loop usb_storage 
>>>> usbhid snd_hda_intel arc4 snd_pcm_oss sg ecb crypto_blkcipher 
>>>> snd_mixer_oss cryptomgr snd_pcm snd_timer tpm_infineon sr_mod usblp snd 
>>>> rng_core cdrom ehci_hcd mac80211 thermal ohci1394 ieee1394 processor 
>>>> evdev thermal_sys tpm uhci_hcd iTCO_wdt iTCO_vendor_support soundcore 
>>>> cfg80211 tpm_bios sky2 hwmon snd_page_alloc intel_agp button [last 
>>>> unloaded: ath5k]
>>>> Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #6
>>>>     
>>> This warning is not the first produced by your system, see the W flag in
>>> the line above. Can you find an earlier warning in your dmesg/log? Or is
>>> it similar to this one?
>>>
>>>   
>>>> Call Trace:
>>>>  <IRQ>  [<ffffffff80236214>] warn_on_slowpath+0x64/0xc0
>>>>  [<ffffffff803c9ec8>] ata_sff_data_xfer+0x98/0xc0
>>>>  [<ffffffff803c96c9>] ata_sff_hsm_move+0x4a9/0x6a0
>>>>  [<ffffffff803c9c13>] ata_sff_interrupt+0x1a3/0x2c0
>>>>  [<ffffffff802748e4>] handle_IRQ_event+0x34/0x70
>>>>  [<ffffffff80275e60>] handle_edge_irq+0xc0/0x160
>>>>  [<ffffffff8020ebac>] do_IRQ+0x7c/0x100
>>>>  [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
>>>>  <EOI>  [<ffffffff8021c800>] lapic_next_event+0x0/0x10
>>>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>>>  [<ffffffffa00564bc>] :processor:acpi_idle_enter_simple+0x1c5/0x235
>>>>  [<ffffffffa00564b2>] :processor:acpi_idle_enter_simple+0x1bb/0x235
>>>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>>>  [<ffffffff803fbce7>] cpuidle_idle_call+0xd7/0x120
>>>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>>>  [<ffffffff80209410>] default_idle+0x0/0x50
>>>>  [<ffffffff8020a720>] cpu_idle+0x60/0xd0

Hmm... This shouldn't happen.  Can you please attach full kernel log
including the boot messages?

Thanks.

-- 
tejun
