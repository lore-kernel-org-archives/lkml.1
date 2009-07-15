Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZGOLpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZGOLpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZGOLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:45:18 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49189 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZGOLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:45:16 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=NgnNa4BYe58A:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=LmnUMDoxnP6Y21a0UqEA:9 a=1ThRXIKabyUAheEiGFIA:7
 a=AFF2GWIj9vqy8akH8VFAlZ9Y8LMA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Possible Suspend to Ram bug?
Date: Wed, 15 Jul 2009 05:45:14 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.30-1-amd64; KDE/4.3.60; x86_64; svn-990302; 2009-06-30)
References: <200907100458.27410.tfjellstrom@shaw.ca> <200907150359.12187.tfjellstrom@shaw.ca> <alpine.LNX.2.00.0907151330180.813@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0907151330180.813@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907150545.14867.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed July 15 2009, Jiri Kosina wrote:
> On Wed, 15 Jul 2009, Thomas Fjellstrom wrote:
> > I'll try with debian's 2.6.30 first. But there's a small issue with
> > that, .30 and .31 seem to have some performance regressions according to
> > sites like phoronix.
>
> You know, there are lies, then horrible lies, then benchmarks, and
> benchmarks done wrong.
>
> Just do your own measurements under your particular workload, and if you
> see any performance regression, just report it.

The benchmarks they run are pretty much what I'd do to test, so I'd more than 
likely get the same results, and waste a bunch of time.

2.6.30 did seem to fix the ssd error. but the first time I suspended, my r8169 
decided to flip out. I had to rmmod and modprobe it to get the network back 
up.

[  867.780034] ------------[ cut here ]------------
[  867.780165] WARNING: at 
/home/blank/debian/kernel/tmp/linux-2.6-2.6.30/debian/build/source_amd64_none/net/sched/sch_generic.c:226 
dev_watchdog+0xc7/0x164()
[  867.780373] Hardware name: GA-MA790FXT-UD5P
[  867.780488] NETDEV WATCHDOG: eth1 (r8169): transmit timed out
[  867.780610] Modules linked in: nvidia(P) powernow_k8 cpufreq_conservative 
cpufreq_stats cpufreq_userspace cpufreq_powersave nfsd exportfs nfs lockd 
fscache nfs_acl auth_rpcgss sunrpc it87 hwmon_vid adt7473 firewire_sbp2 loop 
snd_hda$
[  867.785472] Pid: 0, comm: swapper Tainted: P           2.6.30-1-amd64 #1
[  867.785598] Call Trace:
[  867.785699]  <IRQ>  [<ffffffff804229aa>] ? dev_watchdog+0xc7/0x164
[  867.785877]  [<ffffffff804229aa>] ? dev_watchdog+0xc7/0x164
[  867.786005]  [<ffffffff8024236b>] ? warn_slowpath_common+0x77/0xa3
[  867.786130]  [<ffffffff804228e3>] ? dev_watchdog+0x0/0x164
[  867.786252]  [<ffffffff802423f3>] ? warn_slowpath_fmt+0x51/0x59
[  867.786377]  [<ffffffff802342fe>] ? enqueue_task+0x5c/0x65
[  867.786499]  [<ffffffff802546f7>] ? autoremove_wake_function+0x9/0x2e
[  867.786626]  [<ffffffff804228b7>] ? netif_tx_lock+0x3d/0x69
[  867.786749]  [<ffffffff8040f3fc>] ? netdev_drivername+0x3b/0x40
[  867.786873]  [<ffffffff804229aa>] ? dev_watchdog+0xc7/0x164
[  867.786993]  [<ffffffff80235601>] ? __wake_up+0x30/0x44
[  867.787116]  [<ffffffff804228e3>] ? dev_watchdog+0x0/0x164
[  867.787239]  [<ffffffff8024aa2b>] ? run_timer_softirq+0x193/0x210
[  867.787364]  [<ffffffff8025b465>] ? getnstimeofday+0x55/0xaf
[  867.787487]  [<ffffffff80246f55>] ? __do_softirq+0xac/0x173
[  867.787609]  [<ffffffff80210bcc>] ? call_softirq+0x1c/0x30
[  867.787730]  [<ffffffff802125fa>] ? do_softirq+0x3a/0x7e
[  867.787849]  [<ffffffff80246cd2>] ? irq_exit+0x3f/0x80
[  867.787968]  [<ffffffff80220e63>] ? smp_apic_timer_interrupt+0x87/0x94
[  867.788105]  [<ffffffff802105d3>] ? apic_timer_interrupt+0x13/0x20
[  867.788231]  <EOI>  [<ffffffff80227518>] ? native_safe_halt+0x2/0x3
[  867.788410]  [<ffffffff80216995>] ? default_idle+0x40/0x68
[  867.788531]  [<ffffffff8025d714>] ? clockevents_notify+0x2b/0x75
[  867.788656]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
[  867.788776]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
[  867.788894] ---[ end trace 521854739609a619 ]---
[  867.804550] r8169: eth1: link up
[  915.796566] r8169: eth1: link up
[  963.796491] r8169: eth1: link up
[  989.420829] r8169: eth1: link up

At this point I was getting repeated "link up" messages and even though 
ifconfig said the network was up, there was no actual connectivity. as 
mentioned only rmmod+modprobe of r8169 fixed the problem. It doesn't seem to 
happen often though.

I'll update if i see anymore issues.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
