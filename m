Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYFBBCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYFBBCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYFBBCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:02:41 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:20309 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYFBBCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rRxxta5Vqjs/CH35SeNo/tUtWMEjkrgknFMQu7VLmK5WFFajsefeA7XdUbLvdb4U17Vh75k7wcBM80iYb6ZkCXPlLIi7gxzAIn7WtAQnCJbWBo57llbcKGSvFnt2m0UTizuMV3b9DXwGDXPaMaqJY8DV7aU1sHwZYdxy5ncPmJs=
Message-ID: <dd18b0c30806011802w203f1271m9536f072069df458@mail.gmail.com>
Date: Mon, 2 Jun 2008 01:02:39 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: BUG kmalloc-2048: Poison overwritten
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Machek" <pavel@suse.cz>
In-Reply-To: <200806020125.25918.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com>
	 <200806020125.25918.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 11:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 2 of June 2008, Justin Mattock wrote:
>> I received this after the second simultaneous suspend: (I will try and
>> see if this is re creatable or not)
>
> Suspend to RAM or hibernation?

echo mem > /sys/power/state

>
>> [  232.270737] BUG: unable to handle kernel paging request at 6b6b6c6b
>> [  232.270743] IP: [<c013f96d>] module_put+0x12/0x2b
>> [  232.270750] *pde = 00000000
>> [  232.270753] Oops: 0002 [#1] SMP
>> [  232.270757] Modules linked in: hci_usb cpufreq_ondemand
>> cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
>> ipmi_watchdog ipmi_msghandler uinput wlan_tkip ieee80211_crypt_tkip
>> ieee80211_crypt arpt_mangle arptable_filter arp_tables
>> nf_conntrack_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables
>> x_tables intelfb i2c_i810 i2c_algo_bit coretemp eeprom acpi_cpufreq
>> fglrx(P) applesmc joydev uvcvideo appletouch wlan_scan_sta
>> ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
>> snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
>> pata_acpi thermal ehci_hcd uhci_hcd snd_page_alloc snd_hwdep agpgart
>> video button processor
>> [  232.270800]
>> [  232.270802] Pid: 2690, comm: btdelconn Tainted: P
>> (2.6.26-rc4-00033-g5463508 #4)
>> [  232.270805] EIP: 0060:[<c013f96d>] EFLAGS: 00010246 CPU: 0
>> [  232.270808] EIP is at module_put+0x12/0x2b
>> [  232.270810] EAX: 00000000 EBX: 00000000 ECX: c020f49b EDX: 6b6b6b6b
>> [  232.270812] ESI: f4858830 EDI: f572aab8 EBP: f4893f78 ESP: f4893f78
>> [  232.270815]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [  232.270817] Process btdelconn (pid: 2690, ti=f4892000 task=f7fe6220
>> task.ti=f4892000)
>> [  232.270819] Stack: f4893f8c f8bcb705 f572aaac f5b8bcb0 f572aaa8
>> f4893fa8 c012f90d f5b8bcc0
>> [  232.270826]        f8bcb6a6 f5b8bcb0 f4893fb0 f5b8bcc8 f4893fd0
>> c0130119 00000000 f7fe6220
>> [  232.270832]        c01324cd f4893fbc f4893fbc f5b8bcb0 c0130063
>> 00000000 f4893fe0 c013240d
>> [  232.270838] Call Trace:
>> [  232.270842]  [<f8bcb705>] ? del_conn+0x5f/0x64 [bluetooth]
>> [  232.270854]  [<c012f90d>] ? run_workqueue+0x78/0xfb
>> [  232.270859]  [<f8bcb6a6>] ? del_conn+0x0/0x64 [bluetooth]
>> [  232.270869]  [<c0130119>] ? worker_thread+0xb6/0xc2
>> [  232.270873]  [<c01324cd>] ? autoremove_wake_function+0x0/0x30
>> [  232.270878]  [<c0130063>] ? worker_thread+0x0/0xc2
>> [  232.270882]  [<c013240d>] ? kthread+0x3b/0x62
>> [  232.270885]  [<c01323d2>] ? kthread+0x0/0x62
>> [  232.270889]  [<c01044ef>] ? kernel_thread_helper+0x7/0x10
>> [  232.270896]  =======================
>> [  232.270897] Code: 84 00 00 00 e8 45 fa 0c 00 89 f8 e8 3e fa 0c 00
>> 5a 89 f0 59 5b 5e 5f 5d c3 55 85 c0 89 e5 89 c2 74 20 64 a1 04 d0 50
>> c0 c1 e0 06 <ff> 8c 02 00 01 00 00 83 3a 02 75 0b 8b 82 88 01 00 00 e8
>> 00 a6
>> [  232.270932] EIP: [<c013f96d>] module_put+0x12/0x2b SS:ESP 0068:f4893f78
>> [  232.270937] ---[ end trace c436afcb6083d3a0 ]---
>> [  232.297190] =============================================================================
>> [  232.297190] BUG kmalloc-2048: Poison overwritten
>> [  232.297190] -----------------------------------------------------------------------------
>> [  232.297190]
>> [  232.297190] INFO: 0xf4858848-0xf4858848. First byte 0x6a instead of 0x6b
>> [  232.297190] INFO: Allocated in hci_alloc_dev+0x15/0x51 [bluetooth]
>> age=19928 cpu=0 pid=2815
>> [  232.297190] INFO: Freed in bt_release+0xe/0x10 [bluetooth] age=1
>> cpu=0 pid=2690
>> [  232.297190] INFO: Slab 0xc1690b00 objects=15 used=12 fp=0xf4858830
>> flags=0x400020c3
>> [  232.297190] INFO: Object 0xf4858830 @offset=2096 fp=0xf485b950
>> [  232.297190]
>> [  232.297190] Bytes b4 0xf4858820:  10 0a 00 00 40 93 ff ff 5a 5a 5a
>> 5a 5a 5a 5a 5a ....@.ÿÿZZZZZZZZ
>> [  232.297190]   Object 0xf4858830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf4858840:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkjkkkkkkk
>> [  232.297190]   Object 0xf4858850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf4858860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf4858870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf4858880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf4858890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]   Object 0xf48588a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [  232.297190]  Redzone 0xf4859030:  bb bb bb bb
>>               »»»»
>> [  232.297190]  Padding 0xf4859058:  5a 5a 5a 5a 5a 5a 5a 5a
>>               ZZZZZZZZ
>> [  232.297190] Pid: 1390, comm: knodemgrd_0 Tainted: P      D
>> 2.6.26-rc4-00033-g5463508 #4
>> [  232.297190]  [<c016d1ab>] print_trailer+0xc8/0xd0
>> [  232.297190]  [<c016d226>] check_bytes_and_report+0x73/0x8f
>> [  232.297190]  [<c016d497>] check_object+0xa4/0x18c
>> [  232.297190]  [<c016e051>] __slab_alloc+0x387/0x45f
>> [  232.297190]  [<c016f08d>] __kmalloc+0x85/0xdb
>> [  232.297190]  [<f8ae935b>] ? hpsb_alloc_packet+0x17/0x51 [ieee1394]
>> [  232.297190]  [<c016d1d4>] ? check_bytes_and_report+0x21/0x8f
>> [  232.297190]  [<f8ae935b>] hpsb_alloc_packet+0x17/0x51 [ieee1394]
>> [  232.297190]  [<f8ae93ac>] create_reply_packet+0x17/0x77 [ieee1394]
>> [  232.297190]  [<f8ae97c6>] hpsb_packet_received+0x3ba/0x5db [ieee1394]
>> [  232.297190]  [<c016e089>] ? __slab_alloc+0x3bf/0x45f
>> [  232.297190]  [<f8ae9b29>] hpsb_send_packet+0x142/0x192 [ieee1394]
>> [  232.297190]  [<f8ae9bc3>] hpsb_send_packet_and_wait+0x31/0x47 [ieee1394]
>> [  232.297190]  [<f8aeac66>] hpsb_read+0x5d/0xb3 [ieee1394]
>> [  232.297190]  [<f8aed865>] nodemgr_bus_read+0x40/0x149 [ieee1394]
>> [  232.297190]  [<f8af0382>] csr1212_read_keyval+0x2c0/0x3be [ieee1394]
>> [  232.297190]  [<f8af0655>] csr1212_parse_csr+0x1d5/0x211 [ieee1394]
>> [  232.297190]  [<f8aee756>] nodemgr_host_thread+0x343/0x7b9 [ieee1394]
>> [  232.297190]  [<f8aee413>] ? nodemgr_host_thread+0x0/0x7b9 [ieee1394]
>> [  232.297190]  [<c013240d>] kthread+0x3b/0x62
>> [  232.297190]  [<c01323d2>] ? kthread+0x0/0x62
>> [  232.297190]  [<c01044ef>] kernel_thread_helper+0x7/0x10
>> [  232.297190]  =======================
>> [  232.297190] FIX kmalloc-2048: Restoring 0xf4858848-0xf4858848=0x6b
>> [  232.297190]
>> [  232.297190] FIX kmalloc-2048: Marking all objects used
>>
>> Hopefully this is nothing serious,
>> regards;
>



-- 
Justin P. Mattock
