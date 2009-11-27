Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZK0NqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZK0NqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZK0NqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:46:16 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:60111 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZK0NqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:46:15 -0500
Date: Fri, 27 Nov 2009 14:46:21 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       johannes@sipsolutions.net
Subject: Re: [Bug #14352] WARNING: at net/mac80211/scan.c:267
In-Reply-To: <200911172319.49198.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0911271438340.3429@localhost>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.o1.bUdALB@chimera> <8db1092f0911162204i36dbd472w1d2c88411e151acb@mail.gmail.com> <200911172319.49198.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Nov 2009, Rafael J. Wysocki wrote:

> On Tuesday 17 November 2009, Maciej Rutecki wrote:
> > 2009/11/16 Rafael J. Wysocki <rjw@sisk.pl>:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14352
> > > Subject         : WARNING: at net/mac80211/scan.c:267
> > > Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> > > Date            : 2009-10-08 00:30 (40 days old)
> > > References      : http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7
> > >
> > >
> > 
> > In 2.6.32-rc7 problem seems be fixed.
> 
> Thanks, closing.

looks like this one is still present in rc8:

[ 5724.754068] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time 
out after 500ms.
[ 5725.886986] ------------[ cut here ]------------
[ 5725.887021] WARNING: at net/mac80211/scan.c:267 
ieee80211_scan_completed+0x48/0x198 [mac80211]()
[ 5725.887051] Hardware name: 8741J3G
[ 5725.887054] Modules linked in: fuse ipt_MASQUERADE iptable_nat nf_nat 
rfcomm sco bridge stp llc bnep l2cap nfsd lockd nfs_acl auth_rpcgss 
exportfs sunrpc xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter 
ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm uinput 
snd_hda_codec_analog snd_hda_intel snd_hda_codec arc4 snd_hwdep snd_seq 
ecb iwl3945 snd_seq_device iwlcore snd_pcm snd_timer nsc_ircc mac80211 snd 
irda btusb iTCO_wdt soundcore iTCO_vendor_support bluetooth thinkpad_acpi 
video snd_page_alloc pcspkr output i2c_i801 joydev cfg80211 rfkill 
crc_ccitt yenta_socket rsrc_nonstatic e1000e radeon ttm drm_kms_helper drm 
i2c_algo_bit i2c_core [last unloaded: microcode]
[ 5725.887263] Pid: 436, comm: iwl3945 Not tainted 2.6.32-rc8 #6
[ 5725.887269] Call Trace:
[ 5725.887283]  [<c0436c53>] warn_slowpath_common+0x6a/0x81
[ 5725.887308]  [<f8bd0e8f>] ? ieee80211_scan_completed+0x48/0x198 
[mac80211]
[ 5725.887318]  [<c0436c7c>] warn_slowpath_null+0x12/0x15
[ 5725.887340]  [<f8bd0e8f>] ieee80211_scan_completed+0x48/0x198 
[mac80211]
[ 5725.887370]  [<f8c97b81>] iwl_bg_scan_completed+0x97/0xcf [iwlcore]
[ 5725.887382]  [<c044ad6b>] worker_thread+0x13f/0x1b7
[ 5725.887409]  [<f8c97aea>] ? iwl_bg_scan_completed+0x0/0xcf [iwlcore]
[ 5725.887421]  [<c044e535>] ? autoremove_wake_function+0x0/0x34
[ 5725.887431]  [<c044ac2c>] ? worker_thread+0x0/0x1b7
[ 5725.887441]  [<c044e2f7>] kthread+0x64/0x69
[ 5725.887450]  [<c044e293>] ? kthread+0x0/0x69
[ 5725.887461]  [<c040400f>] kernel_thread_helper+0x7/0x10
[ 5725.887469] ---[ end trace f4077df61007acfa ]---

regards, sebastian
> 
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
