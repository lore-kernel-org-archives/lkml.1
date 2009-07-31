Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbZGaOUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbZGaOUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZGaOUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:20:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51937 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZGaOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:20:32 -0400
Date: Fri, 31 Jul 2009 09:12:46 -0500
From: Clark Williams <williams@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
Message-ID: <20090731091246.1b8e169d@torg>
In-Reply-To: <4A722ABA.1090903@us.ibm.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	<alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	<alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	<alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	<alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	<alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	<4A722ABA.1090903@us.ibm.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7hS0pw.MAUAhTc/I.gchqJO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7hS0pw.MAUAhTc/I.gchqJO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jul 2009 16:20:26 -0700
Darren Hart <dvhltc@us.ibm.com> wrote:

> Thomas Gleixner wrote:
>  > We are pleased to announce the next update to our new preempt-rt
>  > series.
>  >
>  >     - update to 2.6.31-rc4
>  >
>  > This is a major rework of the rt patch series. Thanks to Clark
>  > Williams and John Kacur for providing the merge to 2.6.30 while I was
>  > stabilizing .29-rt. While the 30-rt series looked quite stable, we
>  > decided to skip 30-rt entirely to keep track with the ongoing mainline
>  > development for various reaons. The .31-rt series is planned to be
>  > stabilized as we have done with .29-rt.
>=20
> I hit this on boot on an IBM Thinkpad T60p (Intel Core Duo).  Haven't
> had a chance to dig in yet, but wanted to post sooner rather than later.
>=20
> [    4.764702] Freeing unused kernel memory: 552k freed
> [    4.765205] Write protecting the kernel text: 4552k
> [    4.765389] Write protecting the kernel read-only data: 1776k
> [    4.766458] BUG: sleeping function called from invalid context at=20
> kernel/rtmutex.c:684
> [    4.766596] in_atomic(): 1, irqs_disabled(): 0, pid: 103, name: init
> [    4.766723] Pid: 103, comm: init Not tainted 2.6.31-rc4-rt1-dvh01 #1
> [    4.766848] Call Trace:
> [    4.766973]  [<c012d881>] __might_sleep+0xe1/0x100
> [    4.767099]  [<c056ccba>] rt_spin_lock+0x2a/0x70
> [    4.767224]  [<c018243a>] res_counter_uncharge+0x2a/0x50
> [    4.767350]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
> [    4.767477]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
> [    4.767604]  [<c01d6b87>] page_remove_rmap+0x47/0x50
> [    4.767728]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
> [    4.767852]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
> [    4.767977]  [<c037d634>] ? get_random_int+0xb4/0xe0
> [    4.768114]  [<c0140481>] mmput+0x51/0xc0
> [    4.768237]  [<c01ef651>] flush_old_exec+0x381/0x6c0
> [    4.768361]  [<c01ea0c6>] ? vfs_read+0x126/0x190
> [    4.768484]  [<c01eea3f>] ? kernel_read+0x3f/0x60
> [    4.768609]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
> [    4.768734]  [<c012f06f>] ? __wake_up+0x3f/0x50
> [    4.768859]  [<c01ccfee>] ? kunmap_high+0x7e/0xb0
> [    4.768983]  [<c01ccede>] ? page_address+0x8e/0x90
> [    4.769125]  [<c01cd15b>] ? kmap_high+0x13b/0x4c0
> [    4.769248]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
> [    4.769374]  [<c012f06f>] ? __wake_up+0x3f/0x50
> [    4.769498]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
> [    4.769623]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
> [    4.769747]  [<c01eedbd>] search_binary_handler+0xfd/0x300
> [    4.769872]  [<c01f0568>] do_execve+0x228/0x300
> [    4.769996]  [<c0319626>] ? strncpy_from_user+0x46/0x70
> [    4.770121]  [<c0101b16>] sys_execve+0x36/0x60
> [    4.770244]  [<c0103025>] syscall_call+0x7/0xb
>=20


Ok, here's a traceback I got running 2.6.31-rc4-rt1 on a Lenovo T60 that
had been running for a while:

BUG: scheduling while atomic: gkrellm/0x00000001/2483, CPU#0
Modules linked in: ati_remote pl2303 usbserial fuse i915 drm i2c_algo_bit s=
unrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table loop dm_multipath scsi_=
dh kvm_intel kvm uinput arc4 ecb iwl3945 btusb iwlcore snd_hda_codec_analog=
 bluetooth snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_pcm thinkpad_=
acpi snd_timer hwmon snd cfg80211 soundcore video rfkill iTCO_wdt iTCO_vend=
or_support sr_mod joydev cdrom ata_generic yenta_socket snd_page_alloc pcsp=
kr i2c_i801 i2c_core output e1000e ata_piix rsrc_nonstatic sg ahci libata s=
d_mod scsi_mod dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod u=
hci_hcd ohci_hcd ssb [last unloaded: microcode]
Pid: 2483, comm: gkrellm Not tainted 2.6.31-rc4-rt1 #31
Call Trace:
 [<ffffffff8105742b>] __schedule_bug+0x97/0x9c
 [<ffffffff8153856b>] __schedule+0xc7/0x112c
 [<ffffffff8153c8c6>] ? _atomic_spin_unlock+0x46/0x62
 [<ffffffff81539ad5>] schedule+0x1f/0x70
 [<ffffffff8153b163>] rt_spin_lock_slowlock+0x313/0x475
 [<ffffffff8153c1ed>] rt_spin_lock+0xd4/0xd9
 [<ffffffff810c5d6b>] res_counter_uncharge+0x2e/0x53
 [<ffffffff8115b1f5>] __mem_cgroup_uncharge_common+0x24e/0x376
 [<ffffffff8115b3f7>] mem_cgroup_uncharge_page+0x52/0x54
 [<ffffffff8113e9ca>] page_remove_rmap+0x5a/0x7d
 [<ffffffff8112eb62>] unmap_vmas+0xb0b/0x111b
 [<ffffffff81112ec0>] ? __alloc_pages_nodemask+0x1ea/0xa16
 [<ffffffff81137f16>] unmap_region+0x148/0x294
 [<ffffffff81139940>] do_munmap+0x35d/0x3e5
 [<ffffffff81139a0e>] sys_munmap+0x46/0x5d
 [<ffffffff8100cf72>] system_call_fastpath+0x16/0x1b

Steven seemed to think that we have a mismatched preempt_disable() and
preempt_enable() but I haven't had enough coffee to actually try
debugging it.=20

 Clark

--Sig_/7hS0pw.MAUAhTc/I.gchqJO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpy++MACgkQHyuj/+TTEp2L2QCfcyqSje2/EmkJe9gHRduw5Wav
rbgAmwXQeXl2mRFRQ0ncBM7OFZOHCL5R
=PN4y
-----END PGP SIGNATURE-----

--Sig_/7hS0pw.MAUAhTc/I.gchqJO--
