Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZHTFrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZHTFrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZHTFrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:47:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53654 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZHTFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:47:05 -0400
To: <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Aug 2009 22:46:59 -0700
Message-ID: <m163cjhwa4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>, x86@kernel.org, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not certain who I should route this too, but I just had 2.6.31-rc6
fall over on me.  I don't know how reproducible this will be but
I have a full crash dump if someone is interested in looking into this.

Eric

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
PGD 0 
Thread overran stack, or stack corrupted
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
CPU 0 
Modules linked in: veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table ext4 jbd2 crc16 dm_mirror dm_region_hash dm_log dm_multipath dm_mod uinput kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q ixgbe iTCO_wdt iTCO_vendor_support i2c_i801 mdio e1000e pcspkr serio_raw sg ata_generic pata_acpi ata_piix libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.31-rc6-172084.2009.AroraKernelBeta.fc11.x86_64 #1 PDSBM
RIP: 0010:[<ffffffff8105be8b>]  [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
RSP: 0018:ffff8800017cfe30  EFLAGS: 00010006
RAX: ffff8800365b2928 RBX: ffffffff81744e40 RCX: 0000000000000000
RDX: ffff8800017cfe50 RSI: 0000000000000246 RDI: 0000000000000000
RBP: ffff8800017cfea0 R08: ffff8800017d8c00 R09: ffff8800017cff08
R10: 6b40fbe55cdd76b4 R11: ffffffff81744e40 R12: ffff8800017cfe50
R13: 0000000000000000 R14: ffffffff81746658 R15: ffffffff81746258
FS:  0000000000000000(0000) GS:ffff8800017cc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000001001000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff815b2000, task ffffffff8153f020)
Stack:
 6b40fbe55cdd76b4 ffff880000000100 ffffffff81746a58 ffffffff81745e58
<0> ffff8800365b2928 ffff8800abcd6128 ffffffff81023733 6b40fbe55cdd76b4
<0> 6b40fbe55cdd76b4 0000000000000008 0000000000000001 0000000000000100
Call Trace:
 <IRQ> 
 [<ffffffff81023733>] ? lapic_next_event+0x23/0x3b
 [<ffffffff81056893>] __do_softirq+0xe7/0x1cd
 [<ffffffff8100cfac>] call_softirq+0x1c/0x28
 [<ffffffff8100e8e5>] do_softirq+0x51/0xae
 [<ffffffff810564c6>] irq_exit+0x52/0xa3
 [<ffffffff81024080>] smp_apic_timer_interrupt+0x94/0xb9
 [<ffffffff8100c973>] apic_timer_interrupt+0x13/0x20
 <EOI> 
 [<ffffffff810143f2>] ? mwait_idle+0x9b/0xcc
 [<ffffffff81014394>] ? mwait_idle+0x3d/0xcc
 [<ffffffff8100ad4f>] ? enter_idle+0x33/0x49
 [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
 [<ffffffff81391c75>] ? rest_init+0x79/0x8f
 [<ffffffff815bbf8e>] ? start_kernel+0x3dc/0x3fd
 [<ffffffff815bb2b4>] ? x86_64_start_reservations+0xbb/0xd6
 [<ffffffff815bb3d4>] ? x86_64_start_kernel+0x105/0x128
Code: 49 8b 54 1d 20 48 89 55 b8 4c 89 22 49 89 44 1d 20 49 89 44 1d 18 eb 7e 4c 8b 68 18 48 8b 78 20 48 89 43 08 48 8b 08 48 8b 50 08 <48> 89 51 08 48 89 0a 48 c7 40 08 00 02 20 00 48 c7 00 00 00 00 
RIP  [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
 RSP <ffff8800017cfe30>
CR2: 0000000000000008
