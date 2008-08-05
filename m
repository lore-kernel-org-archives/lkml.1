Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbYHEDoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbYHEDoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYHEDn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:43:56 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:40251 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbYHEDnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:43:53 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: michael@ellerman.id.au
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
	<18582.32935.501672.689845@notabene.brown>
	<87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	<87y73dcd60.fsf@burly.wgtn.ondioline.org>
	<1217860597.12535.2.camel@localhost>
	<87hca05ws4.fsf@burly.wgtn.ondioline.org>
	<20080804205908.GA29890@fieldses.org>
	<1217895418.7951.7.camel@localhost>
Date: Tue, 05 Aug 2008 15:43:52 +1200
In-Reply-To: <1217895418.7951.7.camel@localhost> (Michael Ellerman's message
	of "Tue, 05 Aug 2008 10:16:58 +1000")
Message-ID: <8763qg5don.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Mon, 2008-08-04 at 16:59 -0400, J. Bruce Fields wrote:
>> On Tue, Aug 05, 2008 at 08:51:23AM +1200, Paul Collins wrote:
>> > Michael Ellerman <michael@ellerman.id.au> writes:
>> > 
>> > > On Mon, 2008-08-04 at 22:00 +1200, Paul Collins wrote:
>> > >> Paul Collins <paul@burly.ondioline.org> writes:
>> > >> 
>> > >> > Neil Brown <neilb@suse.de> writes:
>> > >> >> Could you try removing the 'static' declaration for nfsd_acceptable
>> > >> >> and recompile?
>> > >> >> Or maybe try a different compiler?
>> > >> >
>> > >> > I will give these a try this evening.
>> > >> 
>> > >> I built myself a nice new cross compiler:
>> > >> 
>> > >>         powerpc-linux-gnu-gcc-4.1 (GCC) 4.1.3 20080623 (prerelease) (Debian 4.1.2-23)
>> > >> 
>> > >> and rebuilt 94ad374a0751f40d25e22e036c37f7263569d24c.  Running that on
>> > >> the server and 2.6.26 on the client, I got yet another Oops.  This one
>> > >> locked the machine up pretty good, so all I have is a picture:
>> > >> 
>> > >> http://ondioline.org/~paul/DSCN1608.JPG
>> > >
>> > > Wow.
>> > >
>> > > Can you try building a kernel on the server? ie. not over NFS.
>> > 
>> > Built kernels on the server with native gcc 4.2.4 and 4.3.1 and repeated
>> > the build test.
>>  
>> But the build test itself was over nfs?  (And you can't reproduce the
>> same problem without nfs?)
>
> Yeah, I'm not clear on that either. What I was aiming at was can you get
> it to oops somewhere else by not building over NFS - in which case we
> can rule NFS (more or less) out.

I think may be able to rule NFS out now.  I just got this Oops when Xorg
started on boot.

Unable to handle kernel paging request for data at address 0x00000949
Faulting instruction address: 0xc0104190
Oops: Kernel access of bad area, sig: 11 [#1]
PowerMac
Modules linked in: snd_aoa_codec_tas snd_aoa_fabric_layout b43 snd_aoa mac80211 cfg80211 pcmcia snd_aoa_i2sbus snd_pcm_oss snd_pcm snd_page_alloc snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd
NIP: c0104190 LR: c0104138 CTR: c01fbd8c
REGS: eee89c40 TRAP: 0300   Not tainted  (2.6.27-rc1-00158-g643fbd8)
MSR: 00009032 <EE,ME,IR,DR>  CR: 88088222  XER: 20000000
DAR: 00000949, DSISR: 42000000
TASK = c1ebb840[2528] 'Xorg' THREAD: eee88000
GPR00: c0104138 eee89cf0 c1ebb840 00000901 ef507d20 00000007 c0620000 c061ca30 
GPR08: ef507d08 c05ae45c 9e370001 eee89cf0 28002248 101f3ca4 101ee800 101ebf1c 
GPR16: eee89e2c fffffff4 c05d0000 eee89d60 ffffffd8 eee89d68 101ebf20 ef4ebab4 
GPR24: c00d0148 00000000 28088222 ef4eba40 00000901 f0000627 ef3ee5e0 eee89cf0 
NIP [c0104190] proc_lookup_de+0xe0/0xf8
LR [c0104138] proc_lookup_de+0x88/0xf8
Call Trace:
[eee89cf0] [c0104138] proc_lookup_de+0x88/0xf8 (unreliable)
[eee89d10] [c010467c] proc_lookup+0x34/0x4c
[eee89d20] [c00c034c] do_lookup+0x1a4/0x220
[eee89d50] [c00c2010] __link_path_walk+0x18c/0xdd4
[eee89dc0] [c00c2cb0] path_walk+0x58/0xe0
[eee89df0] [c00c2e68] do_path_lookup+0x78/0x17c
[eee89e20] [c00c3b58] user_path_at+0x64/0xa4
[eee89e90] [c00baa64] vfs_stat_fd+0x34/0x74
[eee89ec0] [c00bac2c] vfs_stat+0x30/0x48
[eee89ed0] [c00bac74] sys_stat64+0x30/0x5c
[eee89f40] [c0013aa8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfc4a300
    LR = 0xfc4a2b8
Instruction dump:
4e800020 3860fffe 81610000 800b0004 bb6bffec 7d615b78 7c0803a6 4e800020 
3d20c05b 7c641b78 3929e45c 7f83e378 <913c0048> 4bfc98bd 7f83e378 4bfc7dcd 
---[ end trace 9be805d8b3000d04 ]---


And earlier today I got these three Oopses when I did "du -sh *" in my
homedir:

Oops: Exception in kernel mode, sig: 4 [#1]
PowerMac
Modules linked in: option radeon drm snd_aoa_codec_tas snd_aoa_fabric_layout b43 mac80211 snd_aoa cfg80211 pcmcia snd_aoa_i2sbus snd_pcm_oss snd_pcm snd_page_alloc snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd
NIP: c00d01b4 LR: c00d0148 CTR: c01fbd8c
REGS: ec42bbf0 TRAP: 0700   Not tainted  (2.6.27-rc1-00158-g643fbd8)
MSR: 00089032 <EE,ME,IR,DR>  CR: 24088428  XER: 00000000
TASK = c1c837e0[3610] 'du' THREAD: ec42a000
GPR00: eee15e7c ec42bca0 c1c837e0 00000000 c0f1d4fc 002de7e6 ef306bb0 e9d3d104 
GPR08: c0650000 e9d3fe84 e9d3fe7c c05d0000 24088422 10029cb8 10010a8c 10010f5c 
GPR16: ec42be3c fffffff4 c05d0000 ec42bd70 ffffffd8 ec42bd78 1000f940 ee0c5338 
GPR24: e9d3fe74 c0f0ae20 000126dc c0f1d4fc eee15e00 00000000 002de7e6 ec42bca0 
NIP [c00d01b4] iget_locked+0xfc/0x148
LR [c00d0148] iget_locked+0x90/0x148
Call Trace:
[ec42bca0] [c00d0148] iget_locked+0x90/0x148 (unreliable)
[ec42bcd0] [c011cd60] ext3_iget+0x24/0x53c
[ec42bd00] [c0120dbc] ext3_lookup+0x108/0x144
[ec42bd30] [c00c034c] do_lookup+0x1a4/0x220
[ec42bd60] [c00c22ac] __link_path_walk+0x428/0xdd4
[ec42bdd0] [c00c2cb0] path_walk+0x58/0xe0
[ec42be00] [c00c2e68] do_path_lookup+0x78/0x17c
[ec42be30] [c00c3b58] user_path_at+0x64/0xa4
[ec42bea0] [c00ba884] vfs_lstat_fd+0x34/0x74
[ec42bed0] [c00bab2c] sys_fstatat64+0x88/0x90
[ec42bf40] [c0013aa8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff4fc1c
    LR = 0xff4fbb0
Instruction dump:
93d80020 3d00c065 3d60c05d 39580008 381c007c 812842d0 80ebd00c 39290001 
912842d0 39380010 90f80008 914bd00b <00000000> 91470004 916a0004 811c007c 
---[ end trace 63d4f9f1d8c7a13d ]---
Oops: Exception in kernel mode, sig: 4 [#2]
PowerMac
Modules linked in: option radeon drm snd_aoa_codec_tas snd_aoa_fabric_layout b43 mac80211 snd_aoa cfg80211 pcmcia snd_aoa_i2sbus snd_pcm_oss snd_pcm snd_page_alloc snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd
NIP: c00d01b4 LR: c00d0148 CTR: c01fbd8c
REGS: ee7b7bb0 TRAP: 0700   Tainted: G      D    (2.6.27-rc1-00158-g643fbd8)
MSR: 00089032 <EE,ME,IR,DR>  CR: 28888482  XER: 00000000
TASK = eef1a090[2587] 'emacs' THREAD: ee7b6000
GPR00: ef80e67c ee7b7c60 eef1a090 00000000 c0f13738 f0000000 c0620000 ef616884 
GPR08: c0650000 ebdf6b90 ebdf6b88 c05d0000 28888482 102e8e60 102e2180 102e0000 
GPR16: ee7b7e5c fffffff4 c05d0000 ee7b7d40 ffffffd8 ee7b7d48 1033a630 ef403e94 
GPR24: ebdf6b80 c0f0ae20 00008918 c0f13738 ef80e600 00000000 f0000000 ee7b7c60 
NIP [c00d01b4] iget_locked+0xfc/0x148
LR [c00d0148] iget_locked+0x90/0x148
Call Trace:
[ee7b7c60] [c00d0148] iget_locked+0x90/0x148 (unreliable)
[ee7b7c90] [c00fd314] proc_get_inode+0x34/0x188
[ee7b7cb0] [c0104138] proc_lookup_de+0x88/0xf8
[ee7b7cd0] [c010467c] proc_lookup+0x34/0x4c
[ee7b7ce0] [c00fdf10] proc_root_lookup+0x30/0x64
[ee7b7d00] [c00c034c] do_lookup+0x1a4/0x220
[ee7b7d30] [c00c22ac] __link_path_walk+0x428/0xdd4
[ee7b7da0] [c00c2cb0] path_walk+0x58/0xe0
[ee7b7dd0] [c00c2e68] do_path_lookup+0x78/0x17c
[ee7b7e00] [c00c3db4] __path_lookup_intent_open+0x68/0xdc
[ee7b7e30] [c00c3e50] path_lookup_open+0x28/0x40
[ee7b7e40] [c00c40b0] do_filp_open+0xa4/0x7cc
[ee7b7f00] [c00b30d4] do_sys_open+0x6c/0x108
[ee7b7f30] [c00b31e4] sys_open+0x38/0x50
[ee7b7f40] [c0013aa8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xf1d8560
    LR = 0xf1ea534
Instruction dump:
93d80020 3d00c065 3d60c05d 39580008 381c007c 812842d0 80ebd00c 39290001 
912842d0 39380010 90f80008 914bd00b <00000000> 91470004 916a0004 811c007c 
---[ end trace 63d4f9f1d8c7a13d ]---
Oops: Exception in kernel mode, sig: 4 [#3]
PowerMac
Modules linked in: option radeon drm snd_aoa_codec_tas snd_aoa_fabric_layout b43 mac80211 snd_aoa cfg80211 pcmcia snd_aoa_i2sbus snd_pcm_oss snd_pcm snd_page_alloc snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd
NIP: c00d01b4 LR: c00d0148 CTR: c01fbd8c
REGS: ee7b1be0 TRAP: 0700   Tainted: G      D    (2.6.27-rc1-00158-g643fbd8)
MSR: 00089032 <EE,ME,IR,DR>  CR: 22288428  XER: 00000000
TASK = ee7307e0[2574] 'bash' THREAD: ee7b0000
GPR00: eee15e7c ee7b1c90 ee7307e0 00000000 c0f43e10 0037e752 ef306bb0 ef548e9c 
GPR08: c0650000 e9d3f12c e9d3f124 c05d0000 22288422 100e5894 100e0000 100df49c 
GPR16: ee7b1e2c fffffff4 c05d0000 ee7b1d60 ffffffd8 ee7b1d68 100dde04 ef4f7748 
GPR24: e9d3f11c c0f0ae20 00038ff0 c0f43e10 eee15e00 00000000 0037e752 ee7b1c90 
NIP [c00d01b4] iget_locked+0xfc/0x148
LR [c00d0148] iget_locked+0x90/0x148
Call Trace:
[ee7b1c90] [c00d0148] iget_locked+0x90/0x148 (unreliable)
[ee7b1cc0] [c011cd60] ext3_iget+0x24/0x53c
[ee7b1cf0] [c0120dbc] ext3_lookup+0x108/0x144
[ee7b1d20] [c00c034c] do_lookup+0x1a4/0x220
[ee7b1d50] [c00c22ac] __link_path_walk+0x428/0xdd4
[ee7b1dc0] [c00c2cb0] path_walk+0x58/0xe0
[ee7b1df0] [c00c2e68] do_path_lookup+0x78/0x17c
[ee7b1e20] [c00c3b58] user_path_at+0x64/0xa4
[ee7b1e90] [c00baa64] vfs_stat_fd+0x34/0x74
[ee7b1ec0] [c00bac2c] vfs_stat+0x30/0x48
[ee7b1ed0] [c00bac74] sys_stat64+0x30/0x5c
[ee7b1f40] [c0013aa8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfece5e0
    LR = 0x100671fc
Instruction dump:
93d80020 3d00c065 3d60c05d 39580008 381c007c 812842d0 80ebd00c 39290001 
912842d0 39380010 90f80008 914bd00b <00000000> 91470004 916a0004 811c007c 
---[ end trace 63d4f9f1d8c7a13d ]---

And then all my other windows started disappearing, so I figured it was
time to reboot.


In case anyone wants to disassemble it, I've uploaded the kernel to
http://ondioline.org/~paul/vmlinux-2.6.27-rc1-00158-g643fbd8 and the
config to http://ondioline.org/~paul/config-2.6.27-rc1-00158-g643fbd8

I've rebuilt a whole bunch of times in the course of this little
project, but the all four Oopses in this message are from the very
vmlinux linked above.

I have a couple of patches applied locally (a console font and a
Bluetooth HID quirk), so this is really Linus revision
94ad374a0751f40d25e22e036c37f7263569d24c.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
