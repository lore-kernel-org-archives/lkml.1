Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYGNED6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYGNED6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYGNEDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:03:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbYGNEDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:03:49 -0400
Date: Sun, 13 Jul 2008 21:02:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: 2.6.26-rc9-mmotm oops - suspect
 kernel-schedc-add-missing-attr-parameter.patch
Message-Id: <20080713210252.71f48c73.akpm@linux-foundation.org>
In-Reply-To: <21719.1216005541@turing-police.cc.vt.edu>
References: <3741.1215942353@turing-police.cc.vt.edu>
	<21719.1216005541@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 23:19:01 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Sun, 13 Jul 2008 05:45:53 EDT, Valdis.Kletnieks@vt.edu said:
> > --==_Exmh_1215942353_3043P
> > Content-Type: text/plain; charset=us-ascii
> > 
> > kernel-schedc-add-missing-attr-parameter.patch is my leading suspect, as it's
> > the last thing to poke around in the failing code...
> > 
> > My /etc/rc.local had this in it:
> > 
> > echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> > 
> > Which got me an oops:
> 
> powertop 1.11 just pulled another oops on me, that looks related:
> 
> [ 9802.991006] BUG: unable to handle kernel paging request at ffffffff802291c0
> [ 9802.991006] IP: [<ffffffff8037fba0>] number+0x1e6/0x216
> [ 9802.991006] PGD 203067 PUD 207063 PMD 7f84c163 PTE 229161
> [ 9802.991006] Oops: 0003 [1] PREEMPT SMP 
> [ 9802.991006] last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
> [ 9802.991006] CPU 0 
> [ 9802.991006] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios pcmcia arc4 ecb iwl3945 yenta_socket rsrc_nonstatic rfkill pcmcia_core dcdbas ohci1394 nvidia(P) iTCO_wdt ieee1394 mac80211 video iTCO_vendor_support snd_hda_intel intel_agp output led_class thermal tg3 processor ac battery firmware_class button cfg80211 libphy [last unloaded: microcode]
> [ 9802.991006] Pid: 21426, comm: powertop Tainted: P          2.6.26-rc9-mm1 #2
> [ 9802.991006] RIP: 0010:[<ffffffff8037fba0>]  [<ffffffff8037fba0>] number+0x1e6/0x216
> [ 9802.991006] RSP: 0018:ffff88005188dba8  EFLAGS: 00010293
> [ 9802.991006] RAX: 0000000000000030 RBX: ffff88005188ddb8 RCX: 0000000000000000
> [ 9802.991006] RDX: 00000000fffffffc RSI: 0000000000000000 RDI: 0000000000000000
> [ 9802.991006] RBP: ffff88005188dc48 R08: 00000000ffffffff R09: 0000000000000000
> [ 9802.991006] R10: ffffffffffffffff R11: 000000000000000a R12: ffffffff802291c0
> [ 9802.991006] R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> [ 9802.991006] FS:  00007f85234d76f0(0000) GS:ffffffff80770ec0(0000) knlGS:0000000000000000
> [ 9802.991006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 9802.991006] CR2: ffffffff802291c0 CR3: 0000000067285000 CR4: 00000000000006e0
> [ 9802.991006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 9802.991006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 9802.991006] Process powertop (pid: 21426, threadinfo ffff88005188c000, task ffff88005afe1600)
> [ 9802.991006] Stack:  ffffffff80348e86 0000000000000001 ffff88005188dbf8 00ffffffffffffff
> [ 9802.991006]  ffffffff80349430 ffffffff80349e86 0000000000000001 ffff88006bc43fb0
> [ 9802.991006]  0000000000000203 000000000000002d ffff88005188dc18 ffffffff80561638
> [ 9802.991006] Call Trace:
> [ 9802.991006]  [<ffffffff80348e86>] ? avc_has_perm_noaudit+0x4e/0x62b
> [ 9802.991006]  [<ffffffff80349430>] ? avc_has_perm_noaudit+0x5f8/0x62b
> [ 9802.991006]  [<ffffffff80349e86>] ? avc_has_perm+0x31/0x60
> [ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
> [ 9802.991006]  [<ffffffff8025a95a>] ? __lock_acquire+0x6e/0x1131
> [ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
> [ 9802.991006]  [<ffffffff803808dc>] vsnprintf+0x59e/0x5f0
> [ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f

hm, yes, I'd say that you have fingered the appropriate patch.  But
without that patch, the warnings which it fixes reappear, so we're
busted either way.

For now I think I'll just do this:

--- a/kernel/sched.c~kernel-schedc-add-missing-attr-parameter-fix
+++ a/kernel/sched.c
@@ -7742,6 +7742,7 @@ static ssize_t sched_mc_power_savings_st
 					    struct sysdev_attribute *attr,
 					    const char *buf, size_t count)
 {
+	return 0;
 	return sched_power_savings_store(buf, count, 0);
 }
 static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
@@ -7753,12 +7754,14 @@ static ssize_t sched_smt_power_savings_s
 					    struct sysdev_attribute *attr,
 					    char *page)
 {
+	return 0;
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
 static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
 					    struct sysdev_attribute *attr,
 					     const char *buf, size_t count)
 {
+	return 0;
 	return sched_power_savings_store(buf, count, 1);
 }
 static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
_

and hope that magic happens in Mondays's linux-next.

