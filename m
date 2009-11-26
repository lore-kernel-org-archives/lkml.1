Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZKZNrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZKZNrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZKZNrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:47:22 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36344 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZKZNrV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:47:21 -0500
Message-ID: <4B0E86E8.7000705@linux.vnet.ibm.com>
Date: Thu, 26 Nov 2009 07:47:20 -0600
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Tejun Heo <tj@kernel.org>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com> <4B03BDCC.4080502@kernel.org> <4B0DDB5D.9030202@linux.vnet.ibm.com> <4B0E5901.5050203@redhat.com>
In-Reply-To: <4B0E5901.5050203@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 11/26/2009 03:35 AM, Andrew Theurer wrote:
>>
>>> NMI backtrace for cpu 9
>>> CPU 9:
>>> Modules linked in: tun sunrpc af_packet bridge stp ipv6 binfmt_misc 
>>> dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel 
>>> kvm uinput sr_mod cdrom ata_generic pata_acpi ata_piix joydev libata 
>>> ide_pci_generic usbhid ide_core hid serio_raw cdc_ether usbnet mii 
>>> matroxfb_base matroxfb_DAC1064 matroxfb_accel matroxfb_Ti3026 
>>> matroxfb_g450 g450_pll matroxfb_misc iTCO_wdt i2c_i801 i2c_core 
>>> pcspkr iTCO_vendor_support ioatdma thermal rtc_cmos rtc_core bnx2 
>>> rtc_lib dca thermal_sys hwmon sg button shpchp pci_hotplug qla2xxx 
>>> scsi_transport_fc scsi_tgt sd_mod scsi_mod crc_t10dif ext3 jbd 
>>> mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: processor]
>>> Pid: 5687, comm: qemu-system-x86 Not tainted 
>>> 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1  
>>> -[7947AC1]-
>>> RIP: 0010:[<ffffffff810b802b>]  [<ffffffff810b802b>] 
>>> fire_user_return_notifiers+0x31/0x36
>>> RSP: 0018:ffff88095024df08  EFLAGS: 00000246
>>> RAX: 0000000000000000 RBX: 0000000000000800 RCX: ffff88095024c000
>>> RDX: ffff880028340000 RSI: 0000000000000000 RDI: ffff88095024df58
>>> RBP: ffff88095024df18 R08: 0000000000000000 R09: 0000000000000001
>>> R10: 000000caf1fff62d R11: ffff8805b584de40 R12: 00007fffae48e0f0
>>> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
>>> FS:  00007f45c69d57c0(0000) GS:ffff880028340000(0000) 
>>> knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: fffff9800121056e CR3: 0000000953d36000 CR4: 00000000000026e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Call Trace:
>>> <#DB[1]> <<EOE>> Pid: 5687, comm: qemu-system-x86 Not tainted 
>>> 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1
>>> Call Trace:
>>> <NMI>  [<ffffffff8100af53>] ? show_regs+0x44/0x49
>>>  [<ffffffff812e57b2>] nmi_watchdog_tick+0xc2/0x1b9
>>>  [<ffffffff812e4e73>] do_nmi+0xb0/0x252
>>>  [<ffffffff812e48a0>] nmi+0x20/0x30
>>>  [<ffffffff810b802b>] ? fire_user_return_notifiers+0x31/0x36
>>> <<EOE>>  [<ffffffff8100b844>] do_notify_resume+0x62/0x69
>>>  [<ffffffff8100bf48>] ? int_check_syscall_exit_work+0x9/0x3d
>>>  [<ffffffff8100bf8e>] int_signal+0x12/0x17
>>
> 
> That's a bug with the new user return notifiers.  Is your host kernel 
> preemptible?

preempt is off.
> 
> I think I saw this once but I'm not sure.  I can't reproduce with a host 
> kernel build, some silly guest workload, and 'perf top' to generate an 
> nmi load.
> 

-Andrew


