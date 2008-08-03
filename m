Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYHCGrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYHCGrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHCGro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:47:44 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:46379 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYHCGrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:47:43 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       neilb@suse.de
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
Date: Sun, 03 Aug 2008 18:47:39 +1200
Message-ID: <877iayy4qc.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins <paul@burly.ondioline.org> writes:

> "J. Bruce Fields" <bfields@fieldses.org> writes:
>
>> On Sun, Aug 03, 2008 at 12:03:18AM +1200, Paul Collins wrote:
>>> I just got the oops below on a ppc32 NFS4 server.  I was cross-compiling
>>> Linux with an amd64 client at the time.  The server is running Linus's
>>> tree as of 94ad374a0751f40d25e22e036c37f7263569d24c, the client is
>>> running 2.6.26.
>>> 
>>> The server's kernel was cross-compiled with gcc 4.2.4-3 and binutils
>>> 2.18.50.20080610-1, both built from the Debian sources following their
>>> toolchain-building procedures.
>>
>> Without having really thought about this,
>>
>> 	496d6c32d4d057cb44272d9bd587ff97d023ee92 "nfsd: fix spurious
>> 	EACCESS in reconnect_path()"
>>
>> is one suspect; it might be worth checking whether the problem's
>> reproduceable with that reverted.  But I assume we're not so lucky as to
>> have a 100% reproduceable problem here?
>
> Unknown.  I've kicked off a fresh build.  Here's hoping!

I can trigger it reliably with a 2.6.26 client.  I've also triggered it
with 496d6c32d4d057cb44272d9bd587ff97d023ee92 reverted on the server.

It's harder to trigger with 2.6.27-rc1+ but I managed to get an Oops
on the fourth build after three successful builds on the NFS4 mount.

One of the Oopses I got with 2.6.26 had a slightly different call trace:

Unable to handle kernel paging request for instruction fetch
Faulting instruction address: 0x00000000
Oops: Kernel access of bad area, sig: 11 [#1]
PowerMac
Modules linked in: radeon drm snd_aoa_codec_tas snd_aoa_fabric_layout b43 mac80211 snd_aoa cfg80211 pcmcia snd_aoa_i2sbus snd_pcm_oss snd_pcm snd_page_alloc snd_aoa_soundbus yenta_socket rsrc_nonstatic pcmcia_core ssb uninorth_agp agpgart ehci_hcd ohci_hcd
NIP: 00000000 LR: c0159bb0 CTR: 00000000
REGS: c1f79ca0 TRAP: 0400   Not tainted  (2.6.27-rc1-00158-g643fbd8)
MSR: 40009032 <EE,ME,IR,DR>  CR: 22002022  XER: 20000000
TASK = c1ca5440[2321] 'nfsd' THREAD: c1f78000
GPR00: 00000008 c1f79d50 c1ca5440 82002044 edda2c54 002d6642 002d6642 e05f26bc 
GPR08: ee126e60 00000000 eed7a600 c1f79d50 00000007 00000000 018985fc 01898404 
GPR16: 01898710 018c7894 c04b03f4 c04b03e0 c0173da0 c05f4e84 fffff000 00000001 
GPR24: c00c05dc 00000000 82002044 ef80cca0 edda2c54 ee10d020 c0437120 c1f79d50 
NIP [00000000] 0x0
LR [c0159bb0] exportfs_decode_fh+0xa8/0x200
Call Trace:
[c1f79d50] [c0159b54] exportfs_decode_fh+0x4c/0x200 (unreliable)
[c1f79e80] [c015d568] fh_verify+0x2e8/0x578
[c1f79ed0] [c016b1ec] nfsd4_putfh+0x60/0x78
[c1f79ef0] [c016afd0] nfsd4_proc_compound+0x1e4/0x34c
[c1f79f30] [c015a060] nfsd_dispatch+0xfc/0x220
[c1f79f50] [c0400c70] svc_process+0x3e4/0x6e8
[c1f79f90] [c015a8bc] nfsd+0x1c4/0x294
[c1f79fd0] [c0049e48] kthread+0x5c/0x9c
[c1f79ff0] [c00125c0] kernel_thread+0x44/0x60
Instruction dump:
XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
---[ end trace 3dfa6e448b5c7077 ]---

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
