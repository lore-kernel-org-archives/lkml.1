Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYAIVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYAIVK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYAIVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:10:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58464 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYAIVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:10:18 -0500
Date: Wed, 9 Jan 2008 22:10:16 +0100
From: Jan Kara <jack@suse.cz>
To: Nai Xia <nai.xia@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in touch_atime for kernel 2.6.23.12
Message-ID: <20080109211016.GA20626@atrey.karlin.mff.cuni.cz>
References: <200801052202.10379.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801052202.10379.nai.xia@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  thanks for your report.

> I'm using Debian unstable/sid/lenny with homemade kernel 2.6.23.12 
> patched with tuxonice-3.0-rc3-for-2.6.23.9 and compiled with 
> gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4).
> 
> My root file system is xfs which does not have "noatime" option.
> I was "tar xf"ing a big tar ball when this happen and ultimately leads to a 
> hang  up. I am trying to reproduce it again in a similar setting virutal 
> machine,but till now it does not happen again. 
> I will provide further details if it appears again.
> 
> The objdump for touch_atime of my vmlinux is as follows:
> 
> c0191870 <touch_atime>:
> c0191870:	83 ec 0c             	sub    $0xc,%esp
> c0191873:	89 c1                	mov    %eax,%ecx
> c0191875:	89 1c 24             	mov    %ebx,(%esp)
> c0191878:	89 74 24 04          	mov    %esi,0x4(%esp)
> c019187c:	89 7c 24 08          	mov    %edi,0x8(%esp)
> c0191880:	8b 5a 08             	mov    0x8(%edx),%ebx
> c0191883:	f6 83 1c 01 00 00 02 	testb  $0x2,0x11c(%ebx)
> c019188a:	0f 85 92 00 00 00    	jne    c0191922 <touch_atime+0xb2>
> c0191890:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
> c0191896:	8b 47 30             	mov    0x30(%edi),%eax
> c0191899:	a9 01 04 00 00       	test   $0x401,%eax
> c019189e:	0f 85 7e 00 00 00    	jne    c0191922 <touch_atime+0xb2>
> c01918a4:	f6 c4 08             	test   $0x8,%ah
> c01918a7:	74 10                	je     c01918b9 <touch_atime+0x49>
> c01918a9:	0f b7 43 66          	movzwl 0x66(%ebx),%eax
> c01918ad:	25 00 f0 00 00       	and    $0xf000,%eax
> c01918b2:	3d 00 40 00 00       	cmp    $0x4000,%eax
> c01918b7:	74 69                	je     c0191922 <touch_atime+0xb2>
> c01918b9:	85 c9                	test   %ecx,%ecx
> c01918bb:	0f 84 b7 00 00 00    	je     c0191978 <touch_atime+0x108>
> c01918c1:	8b 51 28             	mov    0x28(%ecx),%edx
> c01918c4:	f6 c2 08             	test   $0x8,%dl
> c01918c7:	75 59                	jne    c0191922 <touch_atime+0xb2>
> c01918c9:	f6 c2 10             	test   $0x10,%dl
> c01918cc:	75 63                	jne    c0191931 <touch_atime+0xc1>
> c01918ce:	83 e2 20             	and    $0x20,%edx
> c01918d1:	8d 73 44             	lea    0x44(%ebx),%esi
> c01918d4:	74 0d                	je     c01918e3 <touch_atime+0x73>
> c01918d6:	8b 43 44             	mov    0x44(%ebx),%eax
> c01918d9:	8d 53 4c             	lea    0x4c(%ebx),%edx
> c01918dc:	39 43 4c             	cmp    %eax,0x4c(%ebx)
> c01918df:	7c 39                	jl     c019191a <touch_atime+0xaa>
> c01918e1:	7e 2f                	jle    c0191912 <touch_atime+0xa2>
> c01918e3:	89 f8                	mov    %edi,%eax
> c01918e5:	e8 e6 04 f9 ff       	call   c0121dd0 <current_fs_time>
> c01918ea:	39 43 44             	cmp    %eax,0x44(%ebx)
> c01918ed:	8d 76 00             	lea    0x0(%esi),%esi
> c01918f0:	74 5e                	je     c0191950 <touch_atime+0xe0>
> c01918f2:	89 53 48             	mov    %edx,0x48(%ebx)
> c01918f5:	ba 01 00 00 00       	mov    $0x1,%edx
> c01918fa:	89 43 44             	mov    %eax,0x44(%ebx)
> c01918fd:	89 d8                	mov    %ebx,%eax
> c01918ff:		8b 74 24 04          	mov    0x4(%esp),%esi
> c0191903:	8b 1c 24             	mov    (%esp),%ebx
> c0191906:	8b 7c 24 08          	mov    0x8(%esp),%edi
> c019190a:	83 c4 0c             	add    $0xc,%esp
> c019190d:	e9 ce 8c 00 00       	jmp    c019a5e0 <__mark_inode_dirty>
> c0191912:	8b 4e 04             	mov    0x4(%esi),%ecx
> c0191915:	39 4a 04             	cmp    %ecx,0x4(%edx)
> c0191918:	79 c9                	jns    c01918e3 <touch_atime+0x73>
> c019191a:	3b 43 54             	cmp    0x54(%ebx),%eax
> c019191d:	8d 53 54             	lea    0x54(%ebx),%edx
> c0191920:	7e 35                	jle    c0191957 <touch_atime+0xe7>
> 
> c0191922:	8b 1c 24             	mov    (%esp),%ebx
  This is really strange - we tried to load a value from a stack and
oopsed...

> c0191925:	8b 74 24 04          	mov    0x4(%esp),%esi
> c0191929:	8b 7c 24 08          	mov    0x8(%esp),%edi
> c019192d:	83 c4 0c             	add    $0xc,%esp
> c0191930:	c3                   	ret    
> c0191931:	0f b7 43 66          	movzwl 0x66(%ebx),%eax
> c0191935:	25 00 f0 00 00       	and    $0xf000,%eax
> c019193a:	3d 00 40 00 00       	cmp    $0x4000,%eax
> c019193f:	74 e1                	je     c0191922 <touch_atime+0xb2>
> c0191941:	83 e2 20             	and    $0x20,%edx
> c0191944:	8d 73 44             	lea    0x44(%ebx),%esi
> c0191947:	74 9a                	je     c01918e3 <touch_atime+0x73>
> c0191949:	eb 8b                	jmp    c01918d6 <touch_atime+0x66>
> c019194b:	90                   	nop    
> c019194c:	8d 74 26 00          	lea    0x0(%esi),%esi
> c0191950:	39 56 04             	cmp    %edx,0x4(%esi)
> c0191953:	75 9d                	jne    c01918f2 <touch_atime+0x82>
> c0191955:	eb cb                	jmp    c0191922 <touch_atime+0xb2>
> c0191957:	89 f6                	mov    %esi,%esi
> c0191959:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi
> c0191960:	0f 8c 7d ff ff ff    	jl     c01918e3 <touch_atime+0x73>
> c0191966:	8b 46 04             	mov    0x4(%esi),%eax
> c0191969:	39 42 04             	cmp    %eax,0x4(%edx)
> c019196c:	8d 74 26 00          	lea    0x0(%esi),%esi
> c0191970:	0f 89 6d ff ff ff    	jns    c01918e3 <touch_atime+0x73>
> c0191976:	eb aa                	jmp    c0191922 <touch_atime+0xb2>
> c0191978:	8d 73 44             	lea    0x44(%ebx),%esi
> c019197b:	90                   	nop    
> c019197c:	8d 74 26 00          	lea    0x0(%esi),%esi
> c0191980:	e9 5e ff ff ff       	jmp    c01918e3 <touch_atime+0x73>
> c0191985:	90                   	nop    
> c0191986:	90                   	nop    
> c0191987:	90                   	nop    
> c0191988:	90                   	nop    
> c0191989:	90                   	nop    
> c019198a:	90                   	nop    
> c019198b:	90                   	nop    
> c019198c:	90                   	nop    
> c019198d:	90                   	nop    
> c019198e:	90                   	nop    
> c019198f:	90                   	nop    
> 
> 
> 
> code: 00 00 00 89 43 44 89 d8 8b 74 24 04 8b ff e9 8b 7c 24 08 83 c4 a0 01 ce 
> 8c 00 00 8b 4e 00 00 4a 04 79 c9 3b 43 8b 54 53 54 7e 35 <8b> 1c 00 00 74 24 
> 04 8b 7c 24 40 28 c4 0c c3 0f b7 43 8b 4c 00
> EIP: [<c0191922>] touch_atime+0xb2/0x120 SS:ESP 0068:da1cbd80
> BUG: unable to handle kernel paging request at virtual address 8efc67ce
> printing eip:
> c0191922
> *pde = 00000000
> Oops: 0000 [#196]
> PREEMPT
> Modules linked in: radeon drm binfmt_misc vboxdrv ipt_MASQUERADE iptable_nat 
> nf_nat nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables nfsd 
> exportfs auth_rpcgss ipv6 nfs lockd sunrpc dm_snapshot usbhid hid pcmcia 
> snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm 
> snd_mixer_oss joydev tsdev snd_seq_dummy snd_seq_oss video backlight 
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq yenta_socket snd_timer 
> snd_seq_device ehci_hcd e1000 uhci_hcd rsrc_nonstatic pcmcia_core snd thermal 
> psmouse i2c_i801 soundcore serio_raw usbcore snd_page_alloc pcspkr evdev
> CPU:    0
> EIP:    0060:[<c0191922>]    Tainted: G      D VLI
  The D flag here indicates that the kernel has already oopsed before.
The first oops will be probably more important (this second one is
likely just an fallout). Are you able to get the first oops?

> EFLAGS: 00010246   (2.6.23.12 #1)
> EIP is at touch_atime+0xb2/0x120
> eax: 477e33e7   ebx: ef611618   ecx: 00000001   edx: 256ccdf0
> esi: ef61165c   edi: efe57800   ebp: 00000000   esp: d6847d80
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process syslogd (pid: 4541, ti=d6846000 task=d8956a80 task.ti=d6846000)
> Stack: 00000000 00000180 cf24a200 c015b415 00001000 00000000 00000000 00000000
> 00000000 cf24a200 cf24a244 ef6116ac ef611618 00000180 00000001 00000000
> 00000000 00000000 00001000 00000000 00000000 00000000 00000020 00000000
> Call Trace:
> [<c015b415>] do_generic_mapping_read+0x3f5/0x4e0
> [<c015d04a>] generic_file_aio_read+0xba/0x1d0
> [<c015a8e0>] file_read_actor+0x0/0x130
> [<c018e06c>] dput+0x1c/0x160
> [<c02b6b06>] xfs_read+0x156/0x380
> [<c02b32ec>] xfs_file_aio_read+0x6c/0x80
> [<c017c845>] do_sync_read+0xd5/0x120
> [<c015d160>] filemap_fault+0x0/0x450
> [<c015d160>] filemap_fault+0x0/0x450
> [<c01302b0>] autoremove_wake_function+0x0/0x50
> [<c011706b>] do_page_fault+0x18b/0x680
> [<c017d111>] vfs_read+0xa1/0x140
> [<c017c770>] do_sync_read+0x0/0x120
> [<c017d551>] sys_read+0x41/0x70
> [<c010411e>] sysenter_past_esp+0x5f/0x85
> =======================
> Code: 00 00 00 89 43 44 89 d8 8b 74 24 04 8b ff e9 8b 7c 24 08 83 c4 a0 01 ce 
> 8c 00 00 8b 4e 00 00 4a 04 79 c9 3b 43 8b 54 53 54 7e 35 <8b> 1c 00 00 74 24 
> 04 8b 7c 24 40 28 c4 0c c3 0f b7 43 8b 4c 00

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
