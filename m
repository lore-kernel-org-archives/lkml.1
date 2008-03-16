Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYCPOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYCPOun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYCPOuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:50:35 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:38696 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751881AbYCPOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:50:34 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2008 10:50:33 EDT
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1205013615.15075.409.camel@localhost>
References: <1205013615.15075.409.camel@localhost>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 15:43:08 +0100
Message-Id: <1205678588.15075.563.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-08 at 23:00 +0100, Laurent GUERBY wrote:
> Hi,
> 
> I have a system with an "AMD64 Phenom 9500" quad core cpu, 4GB RAM,
> "ASUS M3A32 MVP Deluxe wifi" motherboard with latest vendor BIOS
> (0801).
> 
> I tried stock debian etch kernel (Debian 2.6.18.dfsg.1-18etch1),
> machine
> froze with no message, debian etch backport kernel same, and then
> Debian 2.6.24-4 from unstable and I got some messages: machine
> is not frozen but some userland processes are (ps says "Dl" state
> with child in "Zs" state) and "events/3" is taking 100% cpu
> according to top:
> 
>    18 root      15  -5     0    0    0 R  100  0.0  74:59.46
> events/3  
> 
> Got to the same state with ubuntu hardy 2.6.24-8-server kernel. All
> kernels are untainted, no X running anyway.
> 
> It takes a few hours of doing some stuff, in my case bootstraping or
> testing GCC at -j 4, and then the problem happens.

On 2.6.24-1-amd64 (Debian 2.6.24-4) I got a slightly different
backtrace in /var/log/messages after a few hours of stressing the
machine with compilations, see below. The given process
was stuck and unkillable.

Any idea on what to do/try?

Thanks in advance,

Laurent

BUG: soft lockup - CPU#3 stuck for 11s! [sh:7652]
CPU 3:
Modules linked in: nfs tun nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ac battery ipv6 it87 hwmon_vid eeprom loop snd_hda_intel snd_pcm snd_timer snd serio_raw i2c_piix4 soundcore snd_page_alloc ath5k pcspkr psmouse i2c_core mac80211 cfg80211 button sky2 evdev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod sd_mod ata_generic firewire_ohci firewire_core atiixp crc_itu_t ehci_hcd ahci pata_marvell ohci_hcd libata scsi_mod generic ide_core thermal processor fan
Pid: 7652, comm: sh Not tainted 2.6.24-1-amd64 #1
RIP: 0010:[<ffffffff8021bc79>]  [<ffffffff8021bc79>] __smp_call_function_mask+0x9f/0xbf
RSP: 0018:ffff81000131bd68  EFLAGS: 00000297
RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000001
RDX: 00000000000008fc RSI: 00000000000000fc RDI: 0000000000000007
RBP: ffff81000000e000 R08: ffff81011bab5982 R09: ffff81000131bce8
R10: ffff81000131bce8 R11: 0000000000000062 R12: 0000000000000000
R13: 00000000000000d0 R14: ffff81000131bcb8 R15: ffff81000131bcb8
FS:  00002b61abbe4ae0(0000) GS:ffff81011bab58c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000005e1808 CR3: 0000000001303000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8021bc64>] __smp_call_function_mask+0x8a/0xbf
 [<ffffffff80275939>] smp_drain_local_pages+0x0/0x5
 [<ffffffff80275939>] smp_drain_local_pages+0x0/0x5
 [<ffffffff8021bcf7>] smp_call_function_mask+0x5e/0x70
 [<ffffffff80276c3a>] __alloc_pages+0x1ef/0x309
 [<ffffffff8020be2e>] system_call+0x7e/0x83
 [<ffffffff802762a4>] __get_free_pages+0xe/0x32
 [<ffffffff802334bb>] copy_process+0xc1/0x148f
 [<ffffffff8022d224>] set_next_entity+0x18/0x3a
 [<ffffffff8022d2a3>] pick_next_task_fair+0x2d/0x3f
 [<ffffffff8020be2e>] system_call+0x7e/0x83
 [<ffffffff80234985>] do_fork+0x70/0x204
 [<ffffffff8023f29a>] recalc_sigpending+0xe/0x3c
 [<ffffffff8023f366>] sigprocmask+0x9e/0xc0
 [<ffffffff8020c147>] ptregscall_common+0x67/0xb0


guerby@gcc04:~$ cat /proc/7652/stat
7652 (sh) R 7633 3857 3069 34816 3069 4194368 114 0 0 0 0 294472 0 0 20 0 1 0 2369557 8212480 332 18446744073709551615 4194304 4924460 140737476255664 18446744073709551615 47698491444962 262400 65538 0 65538 0 0 0 17 3 0 0 0 0 0
guerby@gcc04:~$ cat /proc/7652/status 
Name:   sh
State:  R (running)
Tgid:   7652
Pid:    7652
PPid:   7633
TracerPid:      27382
Uid:    1000    1000    1000    1000
Gid:    1000    1000    1000    1000
FDSize: 256
Groups: 1000 
VmPeak:     8020 kB
VmSize:     8020 kB
VmLck:         0 kB
VmHWM:      1328 kB
VmRSS:      1328 kB
VmData:     1168 kB
VmStk:        92 kB
VmExe:       716 kB
VmLib:      1560 kB
VmPTE:        24 kB
Threads:        1
SigQ:   12/18446744073709551615
SigPnd: 0000000000040100
ShdPnd: 00000000000f4102
SigBlk: 0000000000010002
SigIgn: 0000000000000000
SigCgt: 0000000000010002
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
Cpus_allowed:   0000000f
Mems_allowed:   00000000,00000001
voluntary_ctxt_switches:        0
nonvoluntary_ctxt_switches:     1


