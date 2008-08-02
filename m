Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYHBSqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYHBSqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYHBSp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:45:58 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52043 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYHBSp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:45:58 -0400
Date: Sat, 2 Aug 2008 14:45:54 -0400
To: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org, linuxppc-dev@ozlabs.org,
       Neil Brown <neilb@suse.de>
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
Message-ID: <20080802184554.GB715@fieldses.org>
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 12:03:18AM +1200, Paul Collins wrote:
> I just got the oops below on a ppc32 NFS4 server.  I was cross-compiling
> Linux with an amd64 client at the time.  The server is running Linus's
> tree as of 94ad374a0751f40d25e22e036c37f7263569d24c, the client is
> running 2.6.26.
> 
> The server's kernel was cross-compiled with gcc 4.2.4-3 and binutils
> 2.18.50.20080610-1, both built from the Debian sources following their
> toolchain-building procedures.

Without having really thought about this,

	496d6c32d4d057cb44272d9bd587ff97d023ee92 "nfsd: fix spurious
	EACCESS in reconnect_path()"

is one suspect; it might be worth checking whether the problem's
reproduceable with that reverted.  But I assume we're not so lucky as to
have a 100% reproduceable problem here?

What do your export options look like?

--b.

> 
> Annoyingly, I can't kill two of the client processes:
> 
>     1 11634 11634   977 ?           -1 D     1000   0:00 make ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- oldconfig vmlinux modules
>     1 23887 11634   977 ?           -1 D     1000   0:00 [powerpc-linux-g]
> 
> Here's the oops.  The instruction dump really was all Xes.
> 
>   Unable to handle kernel paging request for instruction fetch
>   Faulting instruction address: 0x00000000
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   PowerMac
>   Modules linked in: snd_aoa_codec_tas snd_aoa_fabric_layout snd_aoa snd_aoa_i2sbus snd_aoa_soundbus radeon drm b43 mac80211 cfg80211 pcmcia snd_pcm_oss snd_pcm snd_page_alloc yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd [last unloaded: snd_aoa_soundbus]
>   NIP: 00000000 LR: c0159a44 CTR: 00000000
>   REGS: c1d81c70 TRAP: 0400   Not tainted  (2.6.27-rc1-00158-g643fbd8)
>   MSR: 40009032 <EE,ME,IR,DR>  CR: 82002024  XER: 20000000
>   TASK = c1c7b210[2306] 'nfsd' THREAD: c1d80000
>   GPR00: c0159bcc c1d81d20 c1c7b210 82002044 c2e538d4 82002044 002e499d f92d835f
>   GPR08: 00000000 c2e55ac4 c2e55adc c1d81d50 82002024 00000000 018985fc 01898404
>   GPR16: 01898710 018c7894 c04b03f4 c04b03e0 c0173da0 c05f4e84 fffff000 00000001
>   GPR24: c00c05dc 00000000 82002044 00000000 c2e538d4 c2e538d4 c0437120 c1d81d20
>   NIP [00000000] 0x0
>   LR [c0159a44] find_acceptable_alias+0x44/0x108
>   Call Trace:
>   [c1d81d20] [c00cbab8] exportfs_d_alloc+0x40/0x70 (unreliable)
>   [c1d81d50] [c0159bcc] exportfs_decode_fh+0xc4/0x200
>   [c1d81e80] [c015d568] fh_verify+0x2e8/0x578
>   [c1d81ed0] [c016b1ec] nfsd4_putfh+0x60/0x78
>   [c1d81ef0] [c016afd0] nfsd4_proc_compound+0x1e4/0x34c
>   [c1d81f30] [c015a060] nfsd_dispatch+0xfc/0x220
>   [c1d81f50] [c0400c70] svc_process+0x3e4/0x6e8
>   [c1d81f90] [c015a8bc] nfsd+0x1c4/0x294
>   [c1d81fd0] [c0049e48] kthread+0x5c/0x9c
>   [c1d81ff0] [c00125c0] kernel_thread+0x44/0x60
>   Instruction dump:
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   ---[ end trace 88de9451d0d3e759 ]---
> 
> -- 
> Paul Collins
> Wellington, New Zealand
> 
> Dag vijandelijk luchtschip de huismeester is dood
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
