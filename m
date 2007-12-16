Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXLPEbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXLPEbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 23:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXLPEbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 23:31:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbXLPEbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 23:31:32 -0500
Date: Sat, 15 Dec 2007 20:30:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R}
 usage.
Message-Id: <20071215203043.1cba0cf7.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712151255u25610059u946d975324ae128@mail.gmail.com>
References: <a44ae5cd0712141413u4ddbfd06gca259cfc3bc0ab1a@mail.gmail.com>
	<20071214153633.5d8f609a.akpm@linux-foundation.org>
	<a44ae5cd0712141958o10d9a320h3b8173019ac6b0eb@mail.gmail.com>
	<20071215031341.66dc0d05.akpm@linux-foundation.org>
	<a44ae5cd0712151213o59c0df76je273948c965e59c3@mail.gmail.com>
	<a44ae5cd0712151255u25610059u946d975324ae128@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007 15:55:09 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> On Dec 15, 2007 3:13 PM, Miles Lane <miles.lane@gmail.com> wrote:
> >
> > On Dec 15, 2007 6:13 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Fri, 14 Dec 2007 22:58:24 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
> > >
> > > > On Dec 14, 2007 6:36 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > On Fri, 14 Dec 2007 17:13:21 -0500
> > > > > "Miles Lane" <miles.lane@gmail.com> wrote:
> > > > >
> > > > >
> > > > > > Sorry Andrew, I don't know who to forward this problem to.
> > > > > >
> > > > > > I tried running:  find /proc | xargs cat
> > > > > > and got this:
> > > > > >
> > > > > > =================================
> > > > > > [ INFO: inconsistent lock state ]
> > > > > > 2.6.24-rc5-mm1 #26
> > > > > > ---------------------------------
> > > > > > inconsistent {in-softirq-W} -> {softirq-on-R} usage.
> > > > > > cat/6944 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > > > > > BUG: unable to handle kernel paging request at virtual address 0f1eff0b
> > > > > > printing ip: c01fe64d *pde = 00000000
> > > > > > Oops: 0000 [#1] PREEMPT SMP
> > > > > > last sysfs file: /sys/block/sda/sda3/stat
> > > > > > Modules linked in: aes_generic i915 drm rfcomm l2cap bluetooth
> > > > > > cpufreq_stats cpufreq_conservative cpufreq_performance sbs sbshc
> > > > > > dm_crypt sbp2 parport_pc lp parport pcmcia arc4 ecb crypto_blkcipher
> > > > > > cryptomgr crypto_algapi tifm_7xx1 tifm_core yenta_socket
> > > > > > rsrc_nonstatic pcmcia_core iwl3945 iTCO_wdt iTCO_vendor_support
> > > > > > watchdog_core watchdog_dev snd_hda_intel mac80211 snd_pcm_oss
> > > > > > snd_mixer_oss cfg80211 snd_pcm sky2 snd_seq_dummy snd_seq_oss
> > > > > > snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> > > > > > snd_seq_device snd soundcore snd_page_alloc shpchp pci_hotplug
> > > > > > firewire_ohci firewire_core crc_itu_t ata_generic piix ide_core
> > > > > >
> > > > > > Pid: 6944, comm: cat Not tainted (2.6.24-rc5-mm1 #26)
> > > > > > EIP: 0060:[<c01fe64d>] EFLAGS: 00210097 CPU: 0
> > > > > > EIP is at strnlen+0x9/0x1c
> > > > > > EAX: 0f1eff0b EBX: 0f1eff0b ECX: 0f1eff0b EDX: fffffffe
> > > > > > ESI: c05b74f6 EDI: d6267d94 EBP: d6267cc8 ESP: d6267cc8
> > > > > >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > > > > Process cat (pid: 6944, ti=d6267000 task=d5a09000 task.ti=d6267000)
> > > > > > Stack: d6267cfc c01fdd22 00000400 c05b74f4 00000001 c05b78f4 00000000 ffffffff
> > > > > >        ffffffff c048f503 00000400 d5a09000 00000002 d6267d0c c01fdf41 d6267d94
> > > > > >        db68c04a d6267d74 c012ae81 d6267d94 00000028 c05b89f7 00200046 00000000
> > > > > > Call Trace:
> > > > > >  [<c0108eb2>] show_trace_log_lvl+0x12/0x25
> > > > > >  [<c0108f4f>] show_stack_log_lvl+0x8a/0x95
> > > > > >  [<c0108fe4>] show_registers+0x8a/0x1bd
> > > > > >  [<c010922f>] die+0x118/0x1dc
> > > > > >  [<c03cf706>] do_page_fault+0x5a4/0x681
> > > > > >  [<c03cdd72>] error_code+0x72/0x78
> > > > > >  [<c01fdd22>] vsnprintf+0x277/0x40e
> > > > > >  [<c01fdf41>] vscnprintf+0xe/0x1d
> > > > > >  [<c012ae81>] vprintk+0xcb/0x2f3
> > > > > >  [<c012b0be>] printk+0x15/0x17
> > > > > >  [<c0145e55>] print_lock_name+0x4e/0xa2
> > > > > >  [<c0146099>] print_lock+0xe/0x3a
> > > > > >  [<c01464cf>] print_usage_bug+0xbc/0x117
> > > > > >  [<c0146fb6>] mark_lock+0x2e7/0x3fe
> > > > > >  [<c0147b9a>] __lock_acquire+0x498/0xbf4
> > > > > >  [<c014836c>] lock_acquire+0x76/0x9d
> > > > > >  [<c03cd6d2>] _read_lock+0x23/0x32
> > > > > >  [<c03491ae>] sock_i_ino+0x14/0x30
> > > > > >  [<c03c88ed>] packet_seq_show+0x22/0x75
> > > > > >  [<c019b41a>] seq_read+0x19d/0x26f
> > > > > >  [<c01b0ded>] proc_reg_read+0x60/0x74
> > > > > >  [<c01854aa>] vfs_read+0x8a/0x106
> > > > > >  [<c01858a8>] sys_read+0x3b/0x60
> > > > > >  [<c0107cea>] sysenter_past_esp+0x6b/0xc1
> > > > > >  =======================
> > > > > > Code: 01 00 00 00 4f 89 fa 5f 89 d0 5d c3 55 85 c9 89 e5 57 89 c7 89
> > > > > > d0 74 05 f2 ae 75 01 4f 89 f8 5f 5d c3 55 89 c1 89 e5 89 c8 eb 06 <80>
> > > > > > 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 90 55 83
> > > > > > EIP: [<c01fe64d>] strnlen+0x9/0x1c SS:ESP 0068:d6267cc8
> > > > > > note: cat[6944] exited with preempt_count 4
> > > > >
> > > > > I'd say you hit a networking locking bug and then when trying to report
> > > > > that bug, lockdep crashed.
> > > > >
> > > > > The networking bug looks to be around sock_i_ino()'s taking of
> > > > > sk_callback_lock with softirq's enabled.  Perhaps this will fix it.
> > > > >
> > > > > diff -puN net/core/sock.c~a net/core/sock.c
> > > > > --- a/net/core/sock.c~a
> > > > > +++ a/net/core/sock.c
> > > > > @@ -1115,9 +1115,9 @@ int sock_i_uid(struct sock *sk)
> > > > >  {
> > > > >         int uid;
> > > > >
> > > > > -       read_lock(&sk->sk_callback_lock);
> > > > > +       read_lock_bh(&sk->sk_callback_lock);
> > > > >         uid = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_uid : 0;
> > > > > -       read_unlock(&sk->sk_callback_lock);
> > > > > +       read_unlock_bh(&sk->sk_callback_lock);
> > > > >         return uid;
> > > > >  }
> > > > >
> > > > > @@ -1125,9 +1125,9 @@ unsigned long sock_i_ino(struct sock *sk
> > > > >  {
> > > > >         unsigned long ino;
> > > > >
> > > > > -       read_lock(&sk->sk_callback_lock);
> > > > > +       read_lock_bh(&sk->sk_callback_lock);
> > > > >         ino = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_ino : 0;
> > > > > -       read_unlock(&sk->sk_callback_lock);
> > > > > +       read_unlock_bh(&sk->sk_callback_lock);
> > > > >         return ino;
> > > > >  }
> > > > >
> > > > > _
> > > > >
> > > > >
> > > >
> > > > I applied the patch and then tried my test again.  This time my system
> > > > locked up.
> > > > Perhaps I should open a new thread for this, since the problem looks
> > > > pretty different.
> > > >
> > > > Dec 14 21:32:55 feargod kernel: process `cat' is using deprecated
> > > > sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use
> > > > net.ipv6.neigh.default.retran
> > > > s_time_ms instead.
> > > > Dec 14 21:32:55 feargod kernel:
> > > > Dec 14 21:32:55 feargod kernel: =====================================
> > > > Dec 14 21:32:55 feargod kernel: [ BUG: bad unlock balance detected! ]
> > > > Dec 14 21:32:55 feargod kernel: -------------------------------------
> > > > Dec 14 21:32:55 feargod kernel: cat/6180 is trying to release lock
> > > > (kkkkkkk�����H3��) at:
> > > > Dec 14 21:32:55 feargod kernel: [packet_seq_stop+0xe/0x10]
> > > > packet_seq_stop+0xe/0x10
> > > > Dec 14 21:32:55 feargod kernel: but there are no more locks to release!
> > > > Dec 14 21:32:55 feargod kernel:
> > > > Dec 14 21:32:55 feargod kernel: other info that might help us debug this:
> > > > Dec 14 21:32:55 feargod kernel: 2 locks held by cat/6180:
> > > > Dec 14 21:32:55 feargod kernel:  #0:  (&p->lock){--..}, at:
> > > > [crypto_algapi:seq_read+0x25/0x191c1] seq_read+0x25/0x26f
> > > > Dec 14 21:32:55 feargod kernel:  #1:
> > > > (&net->packet.sklist_lock){-.--}, at: [packet_seq_start+0x14/0x4d]
> > > > packet_seq_start+0x14/0x4d
> > >
> > > Bit of a mess.  We don't know whether lockdep is broken or if networking is
> > > just feeding it garbage.  Or both.
> > >
> > > My suspicion is that you've hit bad breakage in networking and lockdep just
> > > isn't sufficiently robust to handle what it's being given.
> > >
> > > Can you suggest a way in which others can reproduce this?
> > >
> > > What happens if you run the same test with CONFIG_LOCKDEP=n?
> >
> > He's what I get with a build with CONFIG_LOCKDEP disabled (this is
> > 100% reproducible):
> >
> > process `head' is using deprecated sysctl (syscall)
> > net.ipv6.neigh.default.retrans_time; Use
> > net.ipv6.neigh.default.retrans
> > _time_ms instead.
> > BUG: unable to handle kernel paging request at virtual address 5a5a5b96
> > printing ip: c02024d5 *pde = 00000000
> > Oops: 0002 [#3] PREEMPT SMP
> > last sysfs file:
> > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/stat
> > Modules linked in: aes_generic i915 drm rfcomm l2cap bluetooth
> > cpufreq_stats cpufreq_conservative cpufreq_performance sbs sbshc
> > dm_crypt sbp2 parport_pc lp parport pcmcia arc4 ecb crypto_blkcipher
> > cryptomgr crypto_algapi snd_hda_intel snd_pcm_oss snd_mixer_oss
> > snd_pcm tifm_7xx1 yenta_socket rsrc_nonstatic iwl3945 tifm_core
> > pcmcia_core snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi cfg80211
> > sky2 snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
> > snd iTCO_wdt iTCO_vendor_support soundcore watchdog_core watchdog_dev
> > snd_page_alloc shpchp pci_hotplug ata_generic piix firewire_ohci
> > firewire_core crc_itu_t ide_core
> >
> > Pid: 6556, comm: head Tainted: G      D (2.6.24-rc5-mm1 #29)
> > EIP: 0060:[<c02024d5>] EFLAGS: 00010013 CPU: 0
> > EIP is at _raw_read_trylock+0x3/0x19

Right.  As I surmised, networking is passing garbage into lockdep and
lockdep didn't like it.

> > EAX: 5a5a5b96 EBX: 00000213 ECX: 00000001 EDX: ee062000
> > ESI: 5a5a5b96 EDI: ef182870 EBP: ee062ed0 ESP: ee062ed0
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process head (pid: 6556, ti=ee062000 task=ef262ba0 task.ti=ee062000)
> > Stack: ee062ee0 c03c746a 5a5a5a52 5a5a5b96 ee062eec c03c74f4 5a5a5a52 ee062efc
> >        c0345f1e c03fd61c 5a5a5a52 ee062f10 c03c29e0 c03fd61c ef182870 5a5a5a52
> >        ee062f50 c019448b 00002000 bff00b17 eefa4600 ef182890 00000000 00000000
> > Call Trace:
> >  [<c0107daa>] show_trace_log_lvl+0x12/0x25
> >  [<c0107e47>] show_stack_log_lvl+0x8a/0x95
> >  [<c0107edc>] show_registers+0x8a/0x1bd
> >  [<c0108127>] die+0x118/0x1dc
> >  [<c03c92f0>] do_page_fault+0x589/0x666
> >  [<c03c79ea>] error_code+0x72/0x78
> >  [<c03c746a>] _read_lock_irqsave+0x2e/0x86
> >  [<c03c74f4>] _read_lock_bh+0x9/0x1f
> >  [<c0345f1e>] sock_i_ino+0x14/0x30
> >  [<c03c29e0>] packet_seq_show+0x22/0x75
> >  [<c019448b>] seq_read+0x192/0x25f
> >  [<c01a9a95>] proc_reg_read+0x60/0x74
> >  [<c017e8f6>] vfs_read+0x8a/0x106
> >  [<c017ece0>] sys_read+0x3b/0x60
> >  [<c0106cae>] sysenter_past_esp+0x6b/0xa1
> >  =======================
> > Code: c2 89 e5 31 c0 86 02 31 c9 84 c0 0f 9f c1 85 c9 74 12 64 a1 08
> > a0 58 c0 89 42 0c 64 a1 00 a0 58 c0 89 42 10 5d 89 c8 c3 55 89 e5 <f0>
> > ff 08 83 38 00 ba 01 00 00 00 79 05 f0 ff 00 30 d2 5d 89 d0
> > EIP: [<c02024d5>] _raw_read_trylock+0x3/0x19 SS:ESP 0068:ee062ed0
> > note: head[6556] exited with preempt_count 2
> 
> The command that reliably reproduces this is:
> cat /proc/net/packet

OK, thanks.
