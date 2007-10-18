Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbXJRXXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbXJRXXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbXJRXX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:23:26 -0400
Received: from pat.uio.no ([129.240.10.15]:58687 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbXJRXXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:23:25 -0400
Subject: Re: [NFS] Kernel Oops in NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jason.V.Mock@L-3Com.com
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Kile, SE Scott @ IS" <scott.kile@L-3Com.com>
In-Reply-To: <F31FEAB987B7C2469181758C14265CFA040BBB7A@gvlexch03.is.l-3com.com>
References: <F31FEAB987B7C2469181758C14265CFA040BBB64@gvlexch03.is.l-3com.com>
	 <F31FEAB987B7C2469181758C14265CFA040BBB7A@gvlexch03.is.l-3com.com>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 19:24:26 -0400
Message-Id: <1192749866.7437.57.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.124)
X-UiO-Scanned: D54A378B027D19D66CA0528A1AB3BDE81FC9D14D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 125 total 4584921 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 16:01 -0500, Jason.V.Mock@L-3Com.com wrote:
> > We've come across an Oops, in what appears to NFS.
> > 
> > 2.6.22.6 vanilla + realtime-lsm
> > RHEL4 over PXE/NFS_ROOT
> > 
> > 
> > Oct  9 14:26:13 WS15 gdm(pam_unix)[6038]: session opened for 
> > user mockj by (uid=0) Oct  9 14:26:48 WS15 gconfd 
> > (mockj-7583): starting (version 2.8.1), pid
> > 7583 user 'mockj'
> > Oct  9 14:26:48 WS15 kernel: BUG: unable to handle kernel 
> > NULL pointer dereference at virtual address 00000004 Oct  9 
> > 14:26:48 WS15 kernel:  printing eip:
> > Oct  9 14:26:48 WS15 kernel: c01a9fb8
> > Oct  9 14:26:48 WS15 kernel: *pde = c691d067 Oct  9 14:26:48 
> > WS15 kernel: Oops: 0000 [#1] Oct  9 14:26:48 WS15 kernel: 
> > PREEMPT SMP Oct  9 14:26:48 WS15 kernel: Modules linked in: 
> > lm85 w83781d hwmon_vid hwmon ipv6 parport_pc lp parport 
> > autofs4 tulip dm_mirror dm_mod button battery ac mct_u232 
> > usbserial uhci_hcd ehci_hcd nvidia(P) e7xxx_edac edac_mc 
> > rng_core i2c_i801 i2c_core aic79xx scsi_transport_spi 
> > ata_piix libata scsi_mod snd_intel8x0 snd_ac97_codec ac97_bus 
> > snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
> > snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
> > snd_timer snd_seq_device snd soundcore realtime commoncap
> > Oct  9 14:26:48 WS15 kernel: CPU:    0
> > Oct  9 14:26:48 WS15 kernel: EIP:    0060:[<c01a9fb8>]    Tainted: P
> > VLI
> > Oct  9 14:26:48 WS15 kernel: EFLAGS: 00210246   (2.6.22-6.0.WSsmp #1)
> > Oct  9 14:26:48 WS15 kernel: EIP is at nfs_lookup+0x11b/0x26a
> > Oct  9 14:26:48 WS15 kernel: eax: 00000000   ebx: c0367600   ecx:
> > 00000000   edx: 00000000
> > Oct  9 14:26:48 WS15 kernel: esi: 00000000   edi: 00000000   ebp:
> > 00000000   esp: f63b5d44
> > Oct  9 14:26:48 WS15 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033
> > ss: 0068
> > Oct  9 14:26:48 WS15 kernel: Process gconfd-2 (pid: 7583, 
> > ti=f63b4000 task=f6273070 task.ti=f63b4000) Oct  9 14:26:48 
> > WS15 kernel: Stack: f63b5d60 f63b5d98 f63b5d9c 7fffffff
> > f63b5ed8 f63ef118 f63f5e8c f63b0002 
> > Oct  9 14:26:48 WS15 kernel:        f63db21c 00000000 
> > c014843e 00000000
> > 0000000e 00000001 00000001 000081c0 
> > Oct  9 14:26:48 WS15 kernel:        00000002 00001459 
> > 000000c9 00000271
> > 00000000 00002000 00000008 00000000
> > Oct  9 14:26:48 WS15 kernel: Call Trace:
> > Oct  9 14:26:48 WS15 kernel:  [<c014843e>] 
> > write_cache_pages+0x235/0x285 Oct  9 14:26:48 WS15 kernel:  
> > [<c01b4332>] nfs_flush_one+0x0/0xe5 Oct  9 14:26:48 WS15 
> > kernel:  [<c01488c5>] mapping_tagged+0x2b/0x32 Oct  9 
> > 14:26:48 WS15 kernel:  [<c016e227>] d_alloc+0x15e/0x166 Oct  
> > 9 14:26:48 WS15 kernel:  [<c0166663>] 
> > lookup_one_len+0xc5/0xe0 Oct  9 14:26:48 WS15 kernel:  
> > [<c01aabba>] nfs_sillyrename+0x12b/0x253 Oct  9 14:26:48 WS15 
> > kernel:  [<c01aba09>] nfs_permission+0x0/0x147 Oct  9 
> > 14:26:48 WS15 kernel:  [<c01aae6e>] nfs_unlink+0x81/0xfc Oct  
> > 9 14:26:48 WS15 kernel:  [<c01667f4>] may_delete+0x55/0x10a 
> > Oct  9 14:26:48 WS15 kernel:  [<c0167a82>] 
> > vfs_unlink+0xa1/0xc5 Oct  9 14:26:48 WS15 kernel:  
> > [<c0167b3b>] do_unlinkat+0x95/0xf5 Oct  9 14:26:48 WS15 
> > kernel:  [<c0105a67>] do_syscall_trace+0x15c/0x19d Oct  9 
> > 14:26:48 WS15 kernel:  [<c0103136>] syscall_call+0x7/0xb Oct  
> > 9 14:26:48 WS15 kernel:  [<c0350000>] 
> > cache_make_upcall+0x40/0x129 Oct  9 14:26:48 WS15 kernel:  
> > ======================= Oct  9 14:26:48 WS15 kernel: Code: 24 
> > 14 8b 00 83 c2 20 8b 58 38 8d 44
> > 24 1c 89 04 24 8b 44 24 18 ff 53 20 83 f8 fe 0f 84 93 00 00 
> > 00 85 c0 89
> > c5 0f 88 3d 01 00 00 <8b> 76 04 8b 54 24 18 89 74 24 10 8b 82 
> > a4 00 00 00 8b 54 24 64 Oct  9 14:26:48 WS15 kernel: EIP: 
> > [<c01a9fb8>] nfs_lookup+0x11b/0x26a SS:ESP 0068:f63b5d4
> > 
> > We haven't seen any negative side-effects other than users 
> > seeing this in Kwrited quite often.  We've yet to update to 
> > 2.6.22.9, however we've examined the change logs and patches 
> > associated with NFS between then and now, and don't see 
> > anything appropriate for the errors we're receiving.  Let me 
> > know if you need anything else for this...
> 
> I was just checking to see if there's anything that I'm missing here, in
> regards to never hearing a single thing back about this.
> 
> - Jason Mock

Well... Your Oops did have the 'tainted' flag set, but in this case I
believe that the issue is already known. Please try

  http://client.linux-nfs.org/Linux-2.6.x/2.6.22/linux-2.6.22-010-fix_nfs_reval_fsid.dif

Trond

