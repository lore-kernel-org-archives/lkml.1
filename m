Return-Path: <linux-kernel-owner+w=401wt.eu-S1751356AbZG3IRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbZG3IRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZG3IRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:17:02 -0400
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:46662 "HELO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751191AbZG3IQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:16:59 -0400
Subject: Re: 2.6.31-rc3 cpufreq bug (null pointer dereference)
From: Christophe Lermytte <christophe.lermytte@thomson.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <20090729203610.GA15826@linux-os.sc.intel.com>
References: <1248206869.4516.6.camel@localhost>
	 <20090725005350.bb4db4ad.akpm@linux-foundation.org>
	 <F9178F5F4473C94D921DE8E5C0D9721619816F@edgmsmail02.eu.thmulti.com>
	 <20090728162255.423a657a.akpm@linux-foundation.org>
	 <1248824511.11545.10724.camel@localhost.localdomain>
	 <20090729203610.GA15826@linux-os.sc.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 10:16:48 +0200
Message-Id: <1248941808.5486.0.camel@thom.lab.edegem.eu.thmulti.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-OriginalArrivalTime: 30 Jul 2009 08:16:50.0042 (UTC) FILETIME=[16922DA0:01CA10EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 13:36 -0700, Pallipadi, Venkatesh wrote:
> On Tue, Jul 28, 2009 at 04:41:51PM -0700, Pallipadi, Venkatesh wrote:
> > On Tue, 2009-07-28 at 16:22 -0700, Andrew Morton wrote:
> > > On Mon, 27 Jul 2009 10:20:02 +0200
> > > "Lermytte Christophe" <Christophe.Lermytte@thomson.net> wrote:
> > > 
> > > > > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > > > Sent: Sat 7/25/2009 9:53 AM
> > > > > 
> > > > > (cc cpufreq@vger.kernel.org)
> > > > >
> > > > > > On Tue, 21 Jul 2009 22:07:49 +0200 Christophe Lermytte <christophe.lermytte@thomson.net> wrote:
> > > > > 
> > > > > > Today, I tried to change the governor to conservative using the GNOME
> > > > > > cpufreqd applet. The applet subsequently hangs and the following appears
> > > > > > in the kernel traces: 
> > > > > > 
> > > > > > [ 3067.249054] BUG: unable to handle kernel NULL pointer dereference at
> > > > > > 00000020
> > > > > > [ 3067.249062] IP: [<c1302d23>] dbs_cpufreq_notifier+0x17/0x2b
> > > > > > [ 3067.249074] *pde = 00000000 
> > > > > > [ 3067.249078] Oops: 0000 [#1] SMP 
> > > > > > [ 3067.249083] last sysfs
> > > > > > file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > > > > > [ 3067.249087] Modules linked in: cdc_wdm cdc_acm
> > > > > > [ 3067.249093] 
> > > > > > [ 3067.249098] Pid: 1346, comm: kondemand/1 Not tainted (2.6.31-rc3 #2)
> > > > > > Latitude D630                   
> > > > > > [ 3067.249103] EIP: 0060:[<c1302d23>] EFLAGS: 00010286 CPU: 1
> > > > > > [ 3067.249108] EIP is at dbs_cpufreq_notifier+0x17/0x2b
> > > > > > [ 3067.249112] EAX: 00000000 EBX: f6959f00 ECX: 00000000 EDX: c278c300
> > > > > > [ 3067.249116] ESI: fffffffe EDI: 00000000 EBP: 00000000 ESP: f6959e78
> > > > > > [ 3067.249120]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > > > > > [ 3067.249124] Process kondemand/1 (pid: 1346, ti=f6958000 task=f69020a0
> > > > > > task.ti=f6958000)
> > > > > > [ 3067.249128] Stack:
> > > > > > [ 3067.249130]  c161ba54 c1427067 f6959f00 00000000 c176d000 f6959f00
> > > > > > c176cfe4 00000000
> > > > > > [ 3067.249139] <0> c103a57e ffffffff 00000000 00000000 00000001 f64de590
> > > > > > f8416980 f6959f00
> > > > > > [ 3067.249149] <0> c103a59c ffffffff 00000000 c100f8b0 f6bcf240 ffffffea
> > > > > > 00000003 00000000
> > > > > > [ 3067.249160] Call Trace:
> > > > > > [ 3067.249166]  [<c1427067>] ? notifier_call_chain+0x2a/0x47
> > > > > > [ 3067.249175]  [<c103a57e>] ? __srcu_notifier_call_chain+0x32/0x47
> > > > > > [ 3067.249181]  [<c103a59c>] ? srcu_notifier_call_chain+0x9/0xc
> > > > > > [ 3067.249193]  [<c100f8b0>] ? acpi_cpufreq_target+0x1a7/0x2b1
> > > > > > [ 3067.249197]  [<c100f5ba>] ? get_measured_perf+0x1f/0x140
> > > > > > [ 3067.249201]  [<c103db6d>] ? getnstimeofday+0x4d/0xd0
> > > > > > [ 3067.249205]  [<c1300802>] ? cpufreq_register_driver+0xb1/0x15b
> > > > > > [ 3067.249209]  [<c100f709>] ? acpi_cpufreq_target+0x0/0x2b1
> > > > > > [ 3067.249213]  [<c13008f5>] ? __cpufreq_driver_target+0x49/0x55
> > > > > > [ 3067.249217]  [<c13029a0>] ? do_dbs_timer+0x262/0x2b8
> > > > > > [ 3067.249222]  [<c1033b50>] ? worker_thread+0x137/0x1b3
> > > > > > [ 3067.249226]  [<c130273e>] ? do_dbs_timer+0x0/0x2b8
> > > > > > [ 3067.249229]  [<c1037042>] ? autoremove_wake_function+0x0/0x2d
> > > > > > [ 3067.249233]  [<c1033a19>] ? worker_thread+0x0/0x1b3
> > > > > > [ 3067.249236]  [<c1036da6>] ? kthread+0x69/0x6e
> > > > > > [ 3067.249240]  [<c1036d3d>] ? kthread+0x0/0x6e
> > > > > > [ 3067.249244]  [<c100334f>] ? kernel_thread_helper+0x7/0x10
> > > > > > [ 3067.249246] Code: c7 44 24 18 ea ff ff ff 8b 44 24 18 83 c4 20 5b 5e
> > > > > > 5f 5d c3 53 8b 01 ba 00 83 6c c1 89 cb 03 14 85 6c b9 66 c1 8b 4a 18 8b
> > > > > > 42 60 <3b> 41 20 77 05 3b 41 1c 73 06 8b 43 08 89 42 60 31 c0 5b c3 53 
> > > > > > [ 3067.249282] EIP: [<c1302d23>] dbs_cpufreq_notifier+0x17/0x2b SS:ESP
> > > > > > 0068:f6959e78
> > > > > > [ 3067.249287] CR2: 0000000000000020
> > > > > > [ 3067.249296] ---[ end trace 5cb870966b6883a7 ]---
> > > > > > 
> > > > > I assume that this is repeatable and that 2.6.30 was OK?
> > > > > 
> > > > > Thanks.
> > > > 
> > > > Yes, I do not encounter it on 2.6.30.2 and I can reproduce it continuously on 2.6.31-rc3 and 2.6.31-rc4.
> > > > 
> > > > Regards.
> > > 
> > > Thanks.  So we have a repeatable kernel-crashing post-2.6.30 regression.
> > > 
> > > this_dbs_info->cur_policy is NULL in dbs_cpufreq_notifier().
> > 
> > 
> > Looks like a bug in cpufreq_conservative.c
> > dbs_cpufreq_notifier() is a frequency change notifier function that
> > operates on policy structure without holding any lock. So, if policy
> > structure goes away for any reason, this is going to fail. Looking at
> > the code, there is nothing preventing this code from crashing in .30 as
> > well.
> > 
> 
> I am sorry. I was totally off the mark in my assessment of this yesterday.
> This is indeed a regression introduced with my changset here
> ee88415caf736b89500f16e0a545614541a45005
> 
> Below patch should fix it. Can you please verify.
> 
> Thanks,
> Venki

Patch applied on .31-rc4, I no longer see the kernel bug message.

Thanks,
Christophe
