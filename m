Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYHESOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYHESOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbYHESNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:13:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:5050 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761326AbYHESNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=rWmq7OVfqDcRwAGd9+ivlE9MUlaRQTetQaHicsvE82fCQA0MKgFkCHR3JhyQ4+Nd9M
         d8gk3arRRDd0e7Asrj+WF8tOdItfhSD+A0hUt+CdGqghqTtU8Rdk5Z5vjPgVGzEjjcUC
         RT4FsqxyxrCK1/X3NqhzsTCFA7C6a6WzDiY9o=
Date: Tue, 5 Aug 2008 23:43:35 +0530
From: Rabin Vincent <rabin@rab.in>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: cat /sys/devices/system/cpu/cpuidle/current_driver
Message-ID: <20080805181335.GB1856@debian>
References: <dd18b0c30808050759h2680842el87b384997978edd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30808050759h2680842el87b384997978edd6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 07:59:31AM -0700, Justin Mattock wrote:
> I noticed a thread about:
> cat /sys/devices/system/cpu/cpuidle/current_driver
> so I decided to see if this happens to me as well.
> sure enough the first try gave me no response the
> second try gave me a segfault <below is in dmesg>
> 
> [  292.680190] BUG: unable to handle kernel paging request at 72890e19
> [  292.680201] IP: [<c02ebd1f>] show_current_driver+0x5/0x4c
> [  292.680215] *pde = 00000000
> [  292.680221] Oops: 0000 [#1] SMP
> [  292.680229] Modules linked in: hci_usb cpufreq_ondemand
> cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
> battery ipmi_watchdog ipmi_msghandler uvcvideo uinput wlan_tkip
> ieee80211_crypt_tkip ieee80211 ieee80211_crypt arpt_mangle
> arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
> iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom
> acpi_cpufreq applesmc wlan_scan_sta ath_rate_sample firewire_ohci
> firewire_core joydev isight_firmware snd_hda_intel ath_pci wlan
> fglrx(P) ohci1394 appletouch snd_pcm ieee1394 ath_hal(P) video ac
> snd_timer ehci_hcd pata_acpi thermal agpgart evdev uhci_hcd
> snd_page_alloc snd_hwdep processor sbshc button
> [  292.680335]
> [  292.680341] Pid: 3645, comm: cat Tainted: P
> (2.6.27-rc1-00156-g94ad374 #5)
> [  292.680346] EIP: 0060:[<c02ebd1f>] EFLAGS: 00210282 CPU: 0
> [  292.680353] EIP is at show_current_driver+0x5/0x4c
> [  292.680358] EAX: f44ae7f4 EBX: c01a982c ECX: 0804e000 EDX: 00001000
> [  292.680362] ESI: f44ae7e0 EDI: c04e0728 EBP: c04e0728 ESP: f1ecff64
> [  292.680367]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  292.680372] Process cat (pid: 3645, ti=f1ece000 task=f1edc4e0
> task.ti=f1ece000)
> [  292.680377] Stack: c04e0a90 f1e0fd00 0804e000 c01a97a1 f1ecff90
> c0175721 f1ecff9c 00001000
> [  292.680392]        f1e0fd00 fffffff7 0804e000 f1ecffb0 c0175a14
> f1ecff9c 00000000 00000000
> [  292.680406]        00000000 00000003 00001000 f1ece000 c0102f9a
> 00000003 0804e000 00001000
> [  292.680421] Call Trace:
> [  292.680425]  [<c01a97a1>] ? sysfs_read_file+0x0/0xe8
> [  292.680436]  [<c0175721>] ? vfs_read+0x8a/0x106
> [  292.680444]  [<c0175a14>] ? sys_read+0x3b/0x60
> [  292.680452]  [<c0102f9a>] ? syscall_call+0x7/0xb
> [  292.680461]  =======================
> [  292.680464] Code: c3 58 5a b8 e0 7a 4e c0 e8 a5 ee 0a 00 89 d8 8b
> 5d fc c9 c3 55 83 c0 30 89 e5 ba 4c 7b 4e c0 e8 3e f4 eb ff 5d c3 61
> 63 70 69 5f <69> 64 6c 65 0a 00 e8 e1 ff 0a 00 a1 e0 4c 5e c0 85 c0 74
> 13 50
> [  292.680548] EIP: [<c02ebd1f>] show_current_driver+0x5/0x4c SS:ESP
> 0068:f1ecff64
> [  292.680559] ---[ end trace d308d2db96f6b752 ]---
> 
> the kernel is tainted(even though I'm trying to have an
> untainted kernel). i.g. video driver

Thanks for the report.  Could you please try this patch posted in the
original thread?

  http://lkml.org/lkml/2008/8/5/314

Rabin
