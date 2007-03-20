Return-Path: <linux-kernel-owner+w=401wt.eu-S966060AbXCTB65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966060AbXCTB65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966068AbXCTB65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:58:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39792 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966060AbXCTB64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:58:56 -0400
Date: Mon, 19 Mar 2007 17:58:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-Id: <20070319175852.c73406f1.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	<45FEE33C.1020706@googlemail.com>
	<20070319140827.285dcc7f.akpm@linux-foundation.org>
	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 22:37:46 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 19/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 19 Mar 2007 20:23:40 +0100
> > Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > akpm@linux-foundation.org napisał(a):
> > > > The mm snapshot broken-out-2007-03-18-02-44.tar.gz has been uploaded to
> > > >
> > > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-18-02-44.tar.gz
> > > >
> > > > It contains the following patches against 2.6.21-rc4:
> > > >
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/filemap.c:123!
> > > invalid opcode: 0000 [#1]
> > > PREEMPT SMP
> > > last sysfs file: devices/platform/w83627hf.656/temp2_input
> > > Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm intel_agp agpgart snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
> > > CPU:    0
> > > EIP:    0060:[<c01615de>]    Not tainted VLI
> > > EFLAGS: 00010002   (2.6.21-rc4-mm1 #13)
> > > EIP is at __remove_from_page_cache+0x42/0x4a
> > > eax: 00000001   ebx: ca263a58   ecx: c043c968   edx: 00000001
> > > esi: c6ad3480   edi: 00000000   ebp: c968dde8   esp: c968dde0
> > > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > Process bash-shared-map (pid: 12273, ti=c968c000 task=c78bc030 task.ti=c968c000)
> > > Stack: ca263a68 c6ad3480 c968ddf8 c016161b c6ad3480 000000da c968de04 c016824d
> > >        c6ad3480 c968de88 c0168525 00001000 00000000 00000000 d17dc000 0005a91a
> > >        00000000 ca263a58 0000005b ffffffff 0000091a 00000110 c54eb5e0 00000004
> > > Call Trace:
> > >  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
> > >  [<c0105308>] show_stack_log_lvl+0x9d/0xac
> > >  [<c0105504>] show_registers+0x1ed/0x34c
> > >  [<c0105780>] die+0x11d/0x234
> > >  [<c0105921>] do_trap+0x8a/0xa3
> > >  [<c010620a>] do_invalid_op+0x97/0xa1
> > >  [<c033f87c>] error_code+0x7c/0x84
> > >  [<c016161b>] remove_from_page_cache+0x35/0x40
> > >  [<c016824d>] truncate_complete_page+0x38/0x42
> > >  [<c0168525>] truncate_inode_pages_range+0x2ce/0x2fe
> > >  [<c016856f>] truncate_inode_pages+0x1a/0x1c
> > >  [<c016ebcc>] vmtruncate+0x40/0xbb
> > >  [<c0193c61>] inode_setattr+0x5c/0x137
> > >  [<c01c328d>] ext3_setattr+0x19c/0x1f8
> > >  [<c0193e75>] notify_change+0x139/0x2ec
> > >  [<c017f666>] do_truncate+0x53/0x6c
> > >  [<c017facc>] do_sys_ftruncate+0x135/0x150
> > >  [<c017fb02>] sys_ftruncate64+0x1b/0x1d
> > >  [<c0104270>] syscall_call+0x7/0xb
> >
> > Ugly - it's hard to determine which patch might have caused that, but I
> > bet it was Nick ;)
> >
> > How hard is it to reproduce?
> 
> I think that it's very easy - run bash_shared_mapping from AutoTest
> for a few seconds.
> 

Yeah, a simple `bash-shared-mapping foo 100000000' goes splat after a few
seconds.

Which indicates that the patchset just isn't working as intended, I think. 
Nick, did you ever run bash-shared-mapping on it?  You should - it's kinda
evil.

I could just drop the BUG_ON, or I could drop the whole patch series.

<dithers>

The kernel with Nick's patchset but without the assert seems to run OK. 
But presumably it's anonymising mapped pages, which is bad.

The kernel without Nick's patchset but with the assert runs OK too.  Under
the principle of mm-has-been-too-flakey-lately, I'll drop the patches:

mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-fix.patch
mm-remove-legacy-cruft.patch

A rollup against rc4 which includes the above patches and which is suitable
for raising fixups against is at http://userweb.kernel.org/~akpm/np.gz


