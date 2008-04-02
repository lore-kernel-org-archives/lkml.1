Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYDBOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYDBOz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYDBOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:55:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:50568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYDBOzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:55:11 -0400
Subject: Re: [>=2.6.23][BUG] Oops on power disconnection
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <5681ec900804020608o62be52c4ted172e18daf24f5b@mail.gmail.com>
References: <5681ec900803300645l5369cda4g119957a4b7f05d17@mail.gmail.com>
	 <5681ec900803300651m6e5f38deke1b7746236e5bb9@mail.gmail.com>
	 <20080402001418.aad6eed2.akpm@linux-foundation.org>
	 <5681ec900804020608o62be52c4ted172e18daf24f5b@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 02 Apr 2008 16:48:33 +0200
Message-Id: <1207147729.30061.9.camel@hammer1.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-04-02 at 18:38 +0530, Sanjeev Aditya Naga wrote:
> Hello Andrew Morton,
> 
> Greetings!
> 
> Thank you for the update. Is there anything I can do
> from my side?
> 
> I thought it was a acpi (dsdt) problem. And based on
> a tutorial, I have tried to extract, fix, recompile the dsdt
> and use it with the kernel. But still I have the same problem.
> Let me know if I shall attach the dsdt (original) decompiled
> code, if that helps.
	
this could be due a general memory corruption problem through ACPICA.
If you get different backtraces on reboots even you only modified things
that do not have to do with the problem, it's probably that and related
to:
﻿http://bugzilla.kernel.org/show_bug.cgi?id=10339

You might want to try the latest kernel or the patch posted there.

   Thomas

> Kind Regards,
> Sanjeev
> 
> On Wed, Apr 2, 2008 at 12:44 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Sun, 30 Mar 2008 19:21:39 +0530 "Sanjeev Aditya Naga" <sanjeev.kernel@gmail.com> wrote:
> >
> >  > Hi,
> >  >
> >  >  This happens everytime there is a power disconnection
> >  >  (switching to battery). Complete dmesg attached. This
> >  >  in particular is of kernel 2.6.24.3.
> >  >
> >  >  Greetings,
> >  >  Kind Regards,
> >  >  Sanjeev
> >  >
> >  >  BUG: unable to handle kernel NULL pointer dereference at virtual
> >  >  address 00000020
> >  >  printing eip: c04c4716 *pde = 578c2067
> >  >  Oops: 0000 [#1] SMP
> >  >  Modules linked in: cbc(U) geode_aes(U) blkcipher(U) aes_i586(U)
> >  >  aes_generic(U) dm_crypt(U) ipt_MASQUERADE(U) iptable_nat(U) nf_nat(U)
> >  >  bridge(U) autofs4(U) nf_conntrack_ipv4(U) xt_state(U) nf_conntrack(U)
> >  >  xt_tcpudp(U) ipt_REJECT(U) iptable_filter(U) ip_tables(U) x_tables(U)
> >  >  cpufreq_ondemand(U) acpi_cpufreq(U) fuse(U) loop(U) dm_mirror(U)
> >  >  dm_multipath(U) dm_mod(U) ipv6(U) snd_hda_intel(U) snd_seq_dummy(U)
> >  >  snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) snd_seq_device(U)
> >  >  snd_pcm_oss(U) sr_mod(U) snd_mixer_oss(U) snd_pcm(U) 8139cp(U)
> >  >  snd_timer(U) button(U) 8139too(U) mii(U) snd_page_alloc(U) cdrom(U)
> >  >  video(U) output(U) snd_hwdep(U) ac(U) snd(U) pcspkr(U) i2c_piix4(U)
> >  >  i2c_core(U) battery(U) joydev(U) soundcore(U) sg(U) pata_atiixp(U)
> >  >  pata_acpi(U) sata_sil(U) ata_generic(U) libata(U) sd_mod(U)
> >  >  scsi_mod(U) ext3(U) jbd(U) mbcache(U) uhci_hcd(U) ohci_hcd(U)
> >  >  ehci_hcd(U)
> >  >
> >  >  Pid: 69, comm: kacpi_notify Not tainted (2.6.24.3 #5)
> >  >  EIP: 0060:[<c04c4716>] EFLAGS: 00010246 CPU: 0
> >  >  EIP is at sysfs_addrm_start+0x21/0x81
> >  >  EAX: c04c47d7 EBX: 00000000 ECX: 00000000 EDX: f78b8000
> >  >  ESI: f78b8eb8 EDI: f78b8ec8 EBP: 00000000 ESP: f78b8ea4
> >  >   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >  >  Process kacpi_notify (pid: 69, ti=f78b8000 task=f78d8000 task.ti=f78b8000)
> >  >  Stack: f229ff54 f229ff54 f5b8d390 fffffff4 c04c4b45 00000000 00000000 00000000
> >  >        00000000 f229ff54 00000000 00000000 f782601c c04c4bab f78b8ee0 c04fe65d
> >  >        f229ff54 c04fe8a8 f722e67f ffffffff ffffffff 00000007 f722e678 f78261d8
> >  >  Call Trace:
> >  >   [<c04c4b45>] create_dir+0x33/0x6c
> >  >   [<c04c4bab>] sysfs_create_dir+0x2d/0x40
> >  >   [<c04fe65d>] kobject_get+0xf/0x13
> >  >   [<c04fe8a8>] kobject_add+0xdd/0x176
> >  >   [<c04fe9eb>] kobject_register+0x19/0x2d
> >  >   [<c05b0ad0>] cpuidle_add_state_sysfs+0x7b/0xe4
> >  >   [<c052660e>] acpi_os_execute_notify+0x0/0x2b
> >  >   [<c05b03fd>] cpuidle_enable_device+0x31/0x9b
> >  >   [<c0545923>] acpi_processor_cst_has_changed+0x40/0x55
> >  >   [<c0543ae2>] acpi_processor_notify+0x8b/0xf4
> >  >   [<c052bcbb>] acpi_ev_notify_dispatch+0x4c/0x55
> >  >   [<c0526630>] acpi_os_execute_notify+0x22/0x2b
> >  >   [<c052660e>] acpi_os_execute_notify+0x0/0x2b
> >  >   [<c043c212>] run_workqueue+0x7d/0x107
> >  >   [<c043fa5b>] prepare_to_wait+0x28/0x45
> >  >   [<c043c35a>] worker_thread+0xbe/0xca
> >  >   [<c043f8ff>] autoremove_wake_function+0x0/0x35
> >  >   [<c043c29c>] worker_thread+0x0/0xca
> >  >   [<c043f679>] kthread+0x38/0x5d
> >  >   [<c043f641>] kthread+0x0/0x5d
> >  >   [<c0406477>] kernel_thread_helper+0x7/0x10
> >  >   =======================
> >  >  Code: c0 89 31 83 c4 14 5b 5e 5f c3 57 b9 04 00 00 00 56 89 c7 53 89
> >  >  c6 83 ec 04 89 d3 31 c0 f3 ab b8 903f 72 c0 89 16 e8 6a cf 16 00 <8b>
> >  >  53 20 b9 ec 42 4c c0 a1 84 e4 83 c0 89 1c 24 e8 44 6e fd ff
> >  >  EIP: [<c04c4716>] sysfs_addrm_start+0x21/0x81 SS:ESP 0068:f78b8ea4
> >
> >  Looks like a cpuidle problem (or at least acpi).
> >
> >  I seem to recall having seen other reports of this?
Then it might be something else...

   Thomas

