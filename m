Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbXK2At3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbXK2At3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXK2AtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:49:18 -0500
Received: from smtp1.Stanford.EDU ([171.67.22.28]:50209 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbXK2AtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:49:15 -0500
X-Greylist: delayed 1401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 19:49:15 EST
Subject: 2.6.23.9-rt12: BUGs
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, nando@ccrma.Stanford.EDU
Content-Type: multipart/mixed; boundary="=-lzkI+dimY9OypGM7tlpj"
Date: Wed, 28 Nov 2007 16:25:48 -0800
Message-Id: <1196295948.29234.9.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lzkI+dimY9OypGM7tlpj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

> I'll try rt12...
> 
> Same problems in rt12, getting lots of "delay of xxx usecs exceeds
> estimated spare time of yyyy; restart" in jackd (on my T61 Lenovo laptop
> running fc7). Does not happen with 2.6.22.10 + rt9. This is both with
> the internal snd-hda-intel card and a pcmcia rme hdsp multiface. 

While trying out 2.6.23.9-rt12 I got the three attached bugs. 
Also attached is the output of dmesg for a clean boot on the machine. 

Jack displays timing problems, similar to when there were timing 
issues with dual processor machines. Still investigating as time 
permits. 

-- Fernando


--=-lzkI+dimY9OypGM7tlpj
Content-Disposition: attachment; filename=bug.1
Content-Type: text/x-vhdl; name=bug.1; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

---- apparently while suspending ---

Nov 27 20:06:01 localhost kernel: Stopping tasks ... done.
Nov 27 20:06:01 localhost kernel: Suspending console(s)
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cach=
e
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] Stopping disk
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:15:00=
.2 disabled
Nov 27 20:06:01 localhost kernel: eth%d: Going into suspend...
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:03:00=
.0 disabled
Nov 27 20:06:01 localhost pcscd: winscard_msg_srv.c:238:SHMProcessEventsCon=
text() select returns with failure: Interrupted system call
Nov 27 20:06:01 localhost pcscd: winscard_svc.c:222:ContextThread() Error i=
n SHMProcessEventsContext
Nov 27 20:06:01 localhost pcscd: winscard_msg_srv.c:238:SHMProcessEventsCon=
text() select returns with failure: Interrupted system call
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1f=
.2 disabled
Nov 27 20:06:01 localhost pcscd: winscard_svc.c:222:ContextThread() Error i=
n SHMProcessEventsContext
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1d=
.7 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1d=
.2 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1d=
.1 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1d=
.0 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1b=
.0 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1a=
.7 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1a=
.1 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:1a=
.0 disabled
Nov 27 20:06:01 localhost kernel: ACPI: PCI interrupt for device 0000:00:19=
.0 disabled
Nov 27 20:06:01 localhost kernel: Disabling non-boot CPUs ...
Nov 27 20:06:01 localhost kernel: Breaking affinity for irq 218
Nov 27 20:06:01 localhost kernel: CPU 1 is now offline
Nov 27 20:06:01 localhost kernel: SMP alternatives: switching to UP code
Nov 27 20:06:01 localhost kernel: BUG: sleeping function called from invali=
d context pm-suspend(3740) at kernel/rtmutex.c:637
Nov 27 20:06:01 localhost gnome-power-manager: (nando) DBUS timed out, but =
recovering
Nov 27 20:06:01 localhost kernel: in_atomic():0 [00000000], irqs_disabled()=
:1
Nov 27 20:06:01 localhost kernel:  [<c062d88d>] __rt_spin_lock+0x21/0x3d
Nov 27 20:06:01 localhost kernel:  [<c0466b68>] free_pages_bulk+0x28/0x188
Nov 27 20:06:01 localhost kernel:  [<c0466d10>] __drain_pages+0x48/0x69
Nov 27 20:06:01 localhost kernel:  [<c0466d4f>] page_alloc_cpu_notify+0x1e/=
0x3d
Nov 27 20:06:01 localhost kernel:  [<c062faa4>] notifier_call_chain+0x2a/0x=
47
Nov 27 20:06:01 localhost kernel:  [<c0439520>] raw_notifier_call_chain+0x1=
7/0x1a
Nov 27 20:06:01 localhost kernel:  [<c044a805>] _cpu_down+0x184/0x242
Nov 27 20:06:01 localhost kernel:  [<c044aa6c>] disable_nonboot_cpus+0x4e/0=
xd2
Nov 27 20:06:01 localhost kernel:  [<c0533915>] acpi_sleep_prepare+0x41/0x4=
8
Nov 27 20:06:01 localhost kernel:  [<c044f213>] suspend_devices_and_enter+0=
x64/0x96
Nov 27 20:06:01 localhost kernel:  [<c044f360>] enter_state+0x11b/0x193
Nov 27 20:06:01 localhost kernel:  [<c044f466>] state_store+0x8e/0xa2
Nov 27 20:06:01 localhost kernel:  [<c044f3d8>] state_store+0x0/0xa2
Nov 27 20:06:01 localhost kernel:  [<c04bb067>] subsys_attr_store+0x27/0x2b
Nov 27 20:06:01 localhost kernel:  [<c04bb2a9>] sysfs_write_file+0xa6/0xd9
Nov 27 20:06:01 localhost kernel:  [<c04bb203>] sysfs_write_file+0x0/0xd9
Nov 27 20:06:01 localhost kernel:  [<c04826eb>] vfs_write+0xa8/0x15a
Nov 27 20:06:01 localhost gnome-power-manager: (nando) Resuming computer
Nov 27 20:06:01 localhost kernel:  [<c0482d14>] sys_write+0x41/0x67
Nov 27 20:06:01 localhost kernel:  [<c040514a>] syscall_call+0x7/0xb
Nov 27 20:06:01 localhost kernel:  [<c0620000>] xfrm_send_policy_notify+0x4=
4f/0x4f4
Nov 27 20:06:01 localhost NetworkManager: <info>  Waking up from sleep.=20
Nov 27 20:06:01 localhost kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov 27 20:06:01 localhost NetworkManager: <info>  Deactivating device eth1.=
=20
Nov 27 20:06:01 localhost kernel: CPU1 is down
Nov 27 20:06:01 localhost NetworkManager: <info>  eth1: Device is fully-sup=
ported using driver 'e1000'.=20
Nov 27 20:06:01 localhost kernel: Intel machine check architecture supporte=
d.
Nov 27 20:06:01 localhost NetworkManager: <info>  nm_device_init(): waiting=
 for device's worker thread to start=20
Nov 27 20:06:01 localhost kernel: Intel machine check reporting enabled on =
CPU#0.
Nov 27 20:06:01 localhost NetworkManager: <info>  nm_device_init(): device'=
s worker thread started, continuing.=20
Nov 27 20:06:01 localhost NetworkManager: <info>  Now managing wired Ethern=
et (802.3) device 'eth1'.=20
Nov 27 20:06:01 localhost kernel: Enabling non-boot CPUs ...
Nov 27 20:06:01 localhost NetworkManager: <info>  Deactivating device eth1.=
=20
Nov 27 20:06:01 localhost kernel: SMP alternatives: switching to SMP code
Nov 27 20:06:01 localhost kernel: Booting processor 1/1 eip 3000
Nov 27 20:06:01 localhost kernel: Initializing CPU#1
Nov 27 20:06:01 localhost kernel: Calibrating delay using timer specific ro=
utine.. 4788.80 BogoMIPS (lpj=3D2394403)
Nov 27 20:06:01 localhost kernel: monitor/mwait feature present.
Nov 27 20:06:01 localhost kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Nov 27 20:06:01 localhost kernel: CPU: L2 cache: 4096K
Nov 27 20:06:01 localhost kernel: CPU: Physical Processor ID: 0
Nov 27 20:06:01 localhost kernel: CPU: Processor Core ID: 1
Nov 27 20:06:01 localhost kernel: Intel machine check architecture supporte=
d.
Nov 27 20:06:01 localhost kernel: Intel machine check reporting enabled on =
CPU#1.
Nov 27 20:06:01 localhost kernel: CPU1: Intel(R) Core(TM)2 Duo CPU     T770=
0  @ 2.40GHz stepping 0a
Nov 27 20:06:01 localhost kernel: CPU1 is up
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> GS=
I 16 (level, low) -> IRQ 20
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:19.0[A] -> GS=
I 20 (level, low) -> IRQ 16
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1a.0[A] -> GS=
I 20 (level, low) -> IRQ 16
Nov 27 20:06:01 localhost kernel: usb usb1: root hub lost power or was rese=
t
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1a.1[B] -> GS=
I 21 (level, low) -> IRQ 17
Nov 27 20:06:01 localhost kernel: usb usb2: root hub lost power or was rese=
t
Nov 27 20:06:01 localhost NetworkManager: <info>  nm-netlink-monitor.c - nm=
_netlink_monitor_event_handler (724) netlink reports device eth1 link now 0=
=20
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1a.7[C] -> GS=
I 22 (level, low) -> IRQ 18
Nov 27 20:06:01 localhost NetworkManager: <info>  nm-device-802-3-ethernet.=
c - nm_device_802_3_ethernet_link_deactivated (149) device eth1 scheduled l=
ink_deactivated_helper=20
Nov 27 20:06:01 localhost NetworkManager: <info>  nm-device-802-3-ethernet.=
c - link_deactivated_helper (129) device eth1 will set active link to FALSE=
=20
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1b.0[B] -> GS=
I 17 (level, low) -> IRQ 21
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GS=
I 16 (level, low) -> IRQ 20
Nov 27 20:06:01 localhost kernel: usb usb3: root hub lost power or was rese=
t
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GS=
I 17 (level, low) -> IRQ 21
Nov 27 20:06:01 localhost kernel: usb usb4: root hub lost power or was rese=
t
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GS=
I 18 (level, low) -> IRQ 22
Nov 27 20:06:01 localhost kernel: usb usb5: root hub lost power or was rese=
t
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GS=
I 19 (level, low) -> IRQ 23
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GS=
I 16 (level, low) -> IRQ 20
Nov 27 20:06:01 localhost kernel: eth%d: Coming out of suspend...
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GS=
I 17 (level, low) -> IRQ 21
Nov 27 20:06:01 localhost kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): =
IRQ=3D[21]  MMIO=3D[f8301000-f83017ff]  Max Packet=3D[2048]  IR/IT contexts=
=3D[4/4]
Nov 27 20:06:01 localhost kernel: ACPI: PCI Interrupt 0000:15:00.2[C] -> GS=
I 18 (level, low) -> IRQ 22
Nov 27 20:06:01 localhost kernel: ata2.00: configured for UDMA/33
Nov 27 20:06:01 localhost kernel: thinkpad_acpi: unknown LID-related hotkey=
 event: 0x5010
Nov 27 20:06:01 localhost kernel: ata1.00: configured for UDMA/100
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] 195371568 512-byte hard=
ware sectors (100030 MB)
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, r=
ead cache: enabled, doesn't support DPO or FUA
Nov 27 20:06:01 localhost kernel: sd 0:0:0:0: [sda] Starting disk
Nov 27 20:06:01 localhost kernel: Restarting tasks ... done.
Nov 27 20:06:01 localhost kernel: ADDRCONF(NETDEV_UP): eth1: link is not re=
ady
Nov 27 20:06:01 localhost kernel: ipw3945: Radio disabled by HW RF Kill Swi=
tch button.

---- two more BUGs

Nov 28 14:46:46 localhost kernel: BUG: unable to handle kernel paging reque=
st at virtual address 00017f14
Nov 28 14:46:46 localhost kernel:  printing eip:
Nov 28 14:46:46 localhost kernel: f8eed17a
Nov 28 14:46:46 localhost kernel: *pde =3D 00000000
Nov 28 14:46:46 localhost kernel: stopped custom tracer.
Nov 28 14:46:46 localhost kernel: Oops: 0000 [#1]
Nov 28 14:46:46 localhost kernel: PREEMPT SMP=20
Nov 28 14:46:46 localhost kernel: last sysfs file: /devices/system/cpu/cpu0=
/cpufreq/scaling_cur_freq
Nov 28 14:46:46 localhost kernel: Modules linked in: snd_hdsp(U) snd_rawmid=
i(U) arc4(U) ecb(U) blkcipher(U) ieee80211_crypt_wep(U) udf(U) i915(U) drm(=
U) thinkpad_acpi(U) hwmon(U) hidp(U) rfcomm(U) l2cap(U) sunrpc(U) nf_conntr=
ack_netbios_ns(U) nf_conntrack_ipv4(U) xt_state(U) nf_conntrack(U) nfnetlin=
k(U) xt_tcpudp(U) ipt_REJECT(U) iptable_filter(U) ip_tables(U) x_tables(U) =
cpufreq_ondemand(U) acpi_cpufreq(U) dm_mirror(U) dm_multipath(U) dm_mod(U) =
video(U) sbs(U) button(U) bay(U) dock(U) battery(U) ac(U) ipv6(U) snd_hda_i=
ntel(U) snd_seq_dummy(U) snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) sn=
d_seq_device(U) snd_pcm_oss(U) snd_mixer_oss(U) snd_pcm(U) sdhci(U) snd_tim=
er(U) snd_page_alloc(U) snd_hwdep(U) mmc_core(U) ohci1394(U) snd(U) hci_usb=
(U) ipw3945(U) bluetooth(U) rtc_cmos(U) sr_mod(U) cdrom(U) i2c_i801(U) e100=
0(U) i2c_core(U) ieee80211(U) ieee80211_crypt(U) soundcore(U) joydev(U) sg(=
U) ata_piix(U) ata_generic(U) libata(U) sd_mod(U) scsi_mod(U) ext3(U) jbd(U=
) mbcache(U) ehci_hcd(U) ohci_hcd(U) uhci_hcd(U)
Nov 28 14:46:46 localhost kernel: CPU:    0
Nov 28 14:46:46 localhost kernel: EIP:    0060:[<f8eed17a>]    Not tainted =
VLI
Nov 28 14:46:46 localhost kernel: EFLAGS: 00010246   (2.6.22.10-1.rt9.1.fc7=
.ccrmart #1)
Nov 28 14:46:46 localhost kernel: EIP is at snd_hdsp_midi_input_available+0=
x2/0x22 [snd_hdsp]
Nov 28 14:46:46 localhost kernel: eax: 00000000   ebx: d9f80288   ecx: c078=
c624   edx: 00000000
Nov 28 14:46:46 localhost kernel: esi: 000f4240   edi: 00000000   ebp: 0000=
0001   esp: c2ccdef4
Nov 28 14:46:46 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000 =
 ss: 0068  preempt:00000001
Nov 28 14:46:46 localhost kernel: Process softirq-high/0 (pid: 5, ti=3Dc2cc=
c000 task=3Dc2ccb970 task.ti=3Dc2ccc000)
Nov 28 14:46:46 localhost kernel: Stack: f8eef56d 00000000 f7d334e0 c2ccb97=
0 f7f0df8c c061a8c5 c2ccdf94 00000086=20
Nov 28 14:46:46 localhost kernel:        ef3e0084 000000b4 c2ccb970 c2ccdf4=
0 c04218fd c2ccc000 e3e6d9e6 000006c3=20
Nov 28 14:46:46 localhost kernel:        c2ccb970 c2ccbb30 c2b98a80 0000000=
0 c04221da f7d33320 f5e38040 00000292=20
Nov 28 14:46:46 localhost kernel: Call Trace:
Nov 28 14:46:46 localhost kernel:  [<f8eef56d>] snd_hdsp_midi_input_read+0x=
1b/0xb3 [snd_hdsp]
Nov 28 14:46:46 localhost kernel:  [<c061a8c5>] __sched_text_start+0x9e5/0x=
afa
Nov 28 14:46:46 localhost kernel:  [<c04218fd>] enqueue_task+0x4c/0x5b
Nov 28 14:46:46 localhost kernel:  [<c04221da>] activate_task+0x76/0x90
Nov 28 14:46:46 localhost kernel:  [<c0445ed8>] rt_mutex_adjust_pi+0x14/0x5=
8
Nov 28 14:46:46 localhost kernel:  [<c0425384>] sched_setscheduler+0x252/0x=
26f
Nov 28 14:46:46 localhost kernel:  [<f8eef619>] hdsp_midi_tasklet+0x14/0x2b=
 [snd_hdsp]
Nov 28 14:46:46 localhost kernel:  [<c042f3aa>] __tasklet_action+0xe5/0x126
Nov 28 14:46:46 localhost kernel:  [<c061abaf>] schedule+0xe0/0xfa
Nov 28 14:46:46 localhost kernel:  [<c042fbbc>] ksoftirqd+0x13c/0x213
Nov 28 14:46:46 localhost kernel:  [<c042fa80>] ksoftirqd+0x0/0x213
Nov 28 14:46:46 localhost kernel:  [<c043b49d>] kthread+0x38/0x5f
Nov 28 14:46:46 localhost kernel:  [<c043b465>] kthread+0x0/0x5f
Nov 28 14:46:46 localhost kernel:  [<c0405ae7>] kernel_thread_helper+0x7/0x=
10
Nov 28 14:46:46 localhost kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov 28 14:46:46 localhost kernel: Code: 8f 01 00 89 10 58 5b 5e 5f 5d c3 85=
 d2 8b 80 14 7f 01 00 74 0a 8b 80 6c 01 00 00 0f b6 c0 c3 8b 80 68 01 00 00=
 0f b6 c0 c3 85 d2 <8b> 80 14 7f 01 00 74 0c 8b 80 8c 01 00 00 25 ff 00 00 =
00 c3 8b=20
Nov 28 14:46:46 localhost kernel: EIP: [<f8eed17a>] snd_hdsp_midi_input_ava=
ilable+0x2/0x22 [snd_hdsp] SS:ESP 0068:c2ccdef4


Nov 28 16:06:52 localhost kernel: ------------[ cut here ]------------
Nov 28 16:06:52 localhost kernel: kernel BUG at lib/list_debug.c:27!
Nov 28 16:06:52 localhost kernel: invalid opcode: 0000 [#1] PREEMPT SMP=20
Nov 28 16:06:52 localhost kernel: Modules linked in: snd_hdsp(U) snd_rawmid=
i(U) i915(U) drm(U) hidp(U) rfcomm(U) l2cap(U) sunrpc(U) nf_conntrack_netbi=
os_ns(U) nf_conntrack_ipv4(U) xt_state(U) nf_conntrack(U) nfnetlink(U) xt_t=
cpudp(U) ipt_REJECT(U) iptable_filter(U) ip_tables(U) x_tables(U) cpufreq_o=
ndemand(U) acpi_cpufreq(U) dm_mirror(U) dm_multipath(U) dm_mod(U) sbs(U) ba=
y(U) ipv6(U) snd_hda_intel(U) snd_seq_dummy(U) snd_seq_oss(U) snd_seq_midi_=
event(U) snd_seq(U) snd_seq_device(U) snd_pcm_oss(U) snd_mixer_oss(U) snd_p=
cm(U) snd_timer(U) snd_page_alloc(U) snd_hwdep(U) battery(U) sdhci(U) ipw39=
45(U) video(U) ohci1394(U) mmc_core(U) snd(U) output(U) ac(U) ieee80211(U) =
ieee80211_crypt(U) sr_mod(U) button(U) cdrom(U) hci_usb(U) e1000(U) bluetoo=
th(U) soundcore(U) i2c_i801(U) thinkpad_acpi(U) i2c_core(U) joydev(U) hwmon=
(U) sg(U) ata_piix(U) ata_generic(U) libata(U) sd_mod(U) scsi_mod(U) ext3(U=
) jbd(U) mbcache(U) ehci_hcd(U) ohci_hcd(U) uhci_hcd(U)
Nov 28 16:06:52 localhost kernel: CPU:    0
Nov 28 16:06:52 localhost kernel: EIP:    0060:[<c04fbfcb>]    Not tainted =
VLI
Nov 28 16:06:52 localhost kernel: EFLAGS: 00010282   (2.6.23.9-1.rt12.1.fc7=
.ccrmart #1)
Nov 28 16:06:52 localhost kernel: EIP is at __list_add+0x26/0x5c
Nov 28 16:06:52 localhost kernel: eax: 00000061   ebx: f0977160   ecx: c071=
2340   edx: c2cd6720
Nov 28 16:06:52 localhost kernel: esi: f71f0df8   edi: f71f1730   ebp: ee6c=
a000   esp: c2cddee4
Nov 28 16:06:52 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000 =
 ss: 0068  preempt:00000001
Nov 28 16:06:52 localhost kernel: Process softirq-tasklet (pid: 10, ti=3Dc2=
cdc000 task=3Dc2cd6720 task.ti=3Dc2cdc000)
Nov 28 16:06:52 localhost kernel: Stack: c06d3339 f0977150 f0977920 f097792=
0 f0977158 f71f0df8 f8bb67b5 c2cd69b0=20
Nov 28 16:06:52 localhost kernel:        00000000 f7c83740 c040417a c2cd672=
0 f7c839d0 c2cd6720 f7f404c0 00000000=20
Nov 28 16:06:52 localhost kernel:        c2d6df8c f7f404c0 f71f0df8 8000000=
0 00000000 00000015 00000016 00000000=20
Nov 28 16:06:52 localhost kernel: Call Trace:
Nov 28 16:06:52 localhost kernel:  [<f8bb67b5>] ipw_irq_tasklet+0x1747/0x1b=
15 [ipw3945]
Nov 28 16:06:52 localhost kernel:  [<c040417a>] __switch_to+0xa3/0x129
Nov 28 16:06:52 localhost kernel:  [<c04321eb>] __tasklet_action+0xe5/0x126
Nov 28 16:06:52 localhost kernel:  [<c062c696>] schedule+0xf1/0x114
Nov 28 16:06:52 localhost kernel:  [<c0432e28>] ksoftirqd+0x157/0x240
Nov 28 16:06:52 localhost kernel:  [<c0432cd1>] ksoftirqd+0x0/0x240
Nov 28 16:06:52 localhost kernel:  [<c043ef59>] kthread+0x38/0x5f
Nov 28 16:06:52 localhost kernel:  [<c043ef21>] kthread+0x0/0x5f
Nov 28 16:06:52 localhost kernel:  [<c0405d9b>] kernel_thread_helper+0x7/0x=
10
Nov 28 16:06:52 localhost kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov 28 16:06:52 localhost kernel: Code: 83 c4 0c 5b c3 56 53 89 c3 83 ec 10=
 8b 41 04 39 d0 74 1c 89 4c 24 0c 89 54 24 04 89 44 24 08 c7 04 24 39 33 6d=
 c0 e8 3a 26 f3 ff <0f> 0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08 =
89 4c 24=20
Nov 28 16:06:52 localhost kernel: EIP: [<c04fbfcb>] __list_add+0x26/0x5c SS=
:ESP 0068:c2cddee4

--=-lzkI+dimY9OypGM7tlpj
Content-Disposition: attachment; filename=dmesg.1
Content-Type: text/plain; name=dmesg.1; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linux version 2.6.23.9-1.rt12.1.fc7.ccrmart (machbuild@planetforge.stanford.edu) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 SMP PREEMPT RT Tue Nov 27 20:09:44 EST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007d6b0000 (usable)
 BIOS-e820: 000000007d6b0000 - 000000007d6cd000 (ACPI data)
 BIOS-e820: 000000007d6cd000 - 000000007d700000 (ACPI NVS)
 BIOS-e820: 000000007d700000 - 000000007e000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
1110MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6900
Entering add_active_range(0, 0, 513712) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   513712
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   513712
On node 0 totalpages: 513712
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 3080 pages used for memmap
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 3887 pages used for memmap
  HighMem zone: 280449 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
Using APIC driver default
ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
ACPI: XSDT 7D6BDFB8, 009C (r1 LENOVO TP-7L        1070  LTP        0)
ACPI: FACP 7D6BE100, 00F4 (r3 LENOVO TP-7L        1070 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7D6BE50C, E6A9 (r1 LENOVO TP-7L        1070 MSFT  3000000)
ACPI: FACS 7D6E4000, 0040
ACPI: SSDT 7D6BE2B4, 0258 (r1 LENOVO TP-7L        1070 MSFT  3000000)
ACPI: ECDT 7D6CCBB5, 0052 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: TCPA 7D6CCC07, 0032 (r2 LENOVO TP-7L        1070 LNVO        1)
ACPI: APIC 7D6CCC39, 0068 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: MCFG 7D6CCCA1, 003C (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: HPET 7D6CCCDD, 0038 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: SLIC 7D6CCDF0, 0176 (r1 LENOVO TP-7L        1070  LTP        0)
ACPI: BOOT 7D6CCF66, 0028 (r1 LENOVO TP-7L        1070  LTP        1)
ACPI: ASF! 7D6CCF8E, 0072 (r16 LENOVO TP-7L        1070 PTL         1)
ACPI: SSDT 7D6E271B, 025F (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E297A, 00A6 (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E2A20, 04F7 (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E2F17, 08BD (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E37D4, 069C (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
swsusp: Registered nosave memory region: 000000000009d000 - 000000000009e000
swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d2000
swsusp: Registered nosave memory region: 00000000000d2000 - 00000000000d4000
swsusp: Registered nosave memory region: 00000000000d4000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order.  Total pages: 506689
Kernel command line: ro root=LABEL=/ rhgb quiet
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2393.987 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2017420k/2054848k available (2245k kernel code, 36252k reserved, 1179k data, 280k init, 1137344k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc075f000 - 0xc07a5000   ( 280 kB)
      .data : 0xc06314de - 0xc07581a4   (1179 kB)
      .text : 0xc0400000 - 0xc06314de   (2245 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet clockevent registered
Calibrating delay using timer specific routine.. 4793.35 BogoMIPS (lpj=2396678)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4736.74 BogoMIPS (lpj=2368371)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
Total of 2 processors activated (9530.09 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 1453932 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
sizeof(vma)=84 bytes
sizeof(page)=56 bytes
sizeof(inode)=532 bytes
sizeof(dentry)=160 bytes
sizeof(ext3inode)=712 bytes
sizeof(buffer_head)=120 bytes
sizeof(skbuff)=180 bytes
sizeof(task_struct)=1648 bytes
Booting paravirtualized kernel on bare hardware
Time: 16:13:17  Date: 11/28/07
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xfdda7, last bus=24
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: EC description table is found, configuring boot EC
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: fc000000-fdffffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: dc000000-df3fffff
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: dfb00000-dfbfffff
PCI: Bridge: 0000:00:1c.3
  IO window: 5000-5fff
  MEM window: d4000000-d5ffffff
  PREFETCH window: df800000-df8fffff
PCI: Bridge: 0000:00:1c.4
  IO window: 6000-6fff
  MEM window: d0000000-d1ffffff
  PREFETCH window: df500000-df5fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00007000-000070ff
  IO window: 00007400-000074ff
  PREFETCH window: f4000000-f7ffffff
  MEM window: 80000000-83ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-afff
  MEM window: f8300000-fbffffff
  PREFETCH window: f4000000-f7ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2883584 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2815k freed
Simple Boot Flag at 0x35 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1196266397.255:1): initialized
krcupreemptd setsched 0
  prio = 98
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: SSDT 7D6E1D72, 0306 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7D6E20FD, 061E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7D6E1CAA, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7D6E2078, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (58 C)
ACPI: Thermal Zone [THM1] (60 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:20c6]
Yenta: ISA IRQ mask 0x04b8, PCI irq 20
Socket status: 30000820
pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
cs: IO port probe 0x7000-0xafff: clean.
pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
  Magic number: 15:1:238
Freeing unused kernel memory: 280k freed
Write protecting the kernel read-only data: 873k
Clocksource tsc unstable (delta = -157297205 ns)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001860
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001880
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000018a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 21, io base 0x000018c0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
pccard: CardBus card inserted into slot 0
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 22, io base 0x000018e0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
input: SynPS/2 Synaptics TouchPad as /class/input/input2
usb 1-1: configuration #1 chosen from 1 choice
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe226400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe226800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
usb 1-1: USB disconnect, address 2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011c30 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011c38 irq 15
usb 1-1: new full speed USB device using uhci_hcd and address 3
ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
usb 1-1: configuration #1 chosen from 1 choice
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1196266405.754:2): selinux=0 auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
ieee80211_crypt: registered algorithm 'NULL'
thinkpad_acpi: ThinkPad ACPI Extras v0.16
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7LET37WW (1.07 ), EC 7KHT21WW-1.05
thinkpad_acpi: Lenovo ThinkPad T61
thinkpad_acpi: radio switch found; radios are enabled
input: ThinkPad Extra Buttons as /class/input/input4
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 19
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:15:58:84:b3:c8
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
ACPI: PCI Interrupt 0000:15:00.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:15:00.1 to 64
net eth1: device_rename: sysfs_create_symlink failed (-17)
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.2d
ipw3945: Copyright(c) 2003-2006 Intel Corporation
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 21)
ACPI: PCI Interrupt 0000:15:00.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:15:00.2 to 64
mmc0: SDHCI at 0xf8301800 irq 22 DMA
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:03:00.0 to 64
ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input7
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /class/input/input8
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input9
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [AC] (on-line)
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00016c20001618d4]
PCI: Enabling device 0000:16:00.0 (0080 -> 0082)
ACPI: PCI Interrupt 0000:16:00.0[A] -> GSI 16 (level, low) -> IRQ 20
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
hda_intel: probe_mask set to 0x1 for device 17aa:20ac
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA /usr/src/rpm/BUILD/alsa-kmod-1.0.15/_kmod_build_rt/pci/rme9652/../../alsa-kernel/pci/rme9652/hdsp.c:798: Hammerfall-DSP: wait for FIFO status <= 0 failed after 30 iterations
ALSA /usr/src/rpm/BUILD/alsa-kmod-1.0.15/_kmod_build_rt/pci/rme9652/../../alsa-kernel/pci/rme9652/hdsp.c:663: Hammerfall-DSP: loading firmware
ALSA /usr/src/rpm/BUILD/alsa-kmod-1.0.15/_kmod_build_rt/pci/rme9652/../../alsa-kernel/pci/rme9652/hdsp.c:696: Hammerfall-DSP: finished firmware loading
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
floppy0: no floppy controllers found
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: \_SB_.PCI0.SATA.SCND.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.SATA.SCND.MSTR: Adding notify handler
ACPI: Error installing bay notify handler
ACPI: Bay [\_SB_.PCI0.SATA.SCND.MSTR] Added
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 3068372k swap on /dev/sda5.  Priority:-1 extents:1 across:3068372k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
e1000: eth1: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
audit(1196295243.553:3): audit_pid=2122 old=0 by auid=4294967295
ipw3945: Detected geography ABG (11 802.11bg channels, 13 802.11a channels)
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
ALSA /usr/src/rpm/BUILD/alsa-kmod-1.0.15/_kmod_build_rt/pci/rme9652/../../alsa-kernel/pci/rme9652/hdsp.c:648: Hammerfall-DSP: no Digiface or Multiface connected!
eth1: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized i915 1.6.0 20060119 on minor 0
eth0: no IPv6 routers present
eth1: no IPv6 routers present

--=-lzkI+dimY9OypGM7tlpj--

