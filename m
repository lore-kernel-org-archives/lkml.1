Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZJ3K5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZJ3K5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZJ3K5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:57:17 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57032 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZJ3K5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Hvd26g3/jfouNZIr6nBVzlDBxfTIX21hVdwz4LHCcqPAU8rAzuCVrN4MRPiEpDFN43
         KB7k/ugxFVGJ/VkxdVHBC/B5taDEESIV/4ijnmFJvZWjeqDMBGTeuBXVhsd/X2xWXq/2
         2vjGUSl1OfLrlUytlbsxug75LMeNIgJ/YNPzA=
Date: Fri, 30 Oct 2009 06:57:08 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: Johannes Berg <johannes@sipsolutions.net>
cc: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: OOPS in cfg80211_conn_work
In-Reply-To: <1256885343.3555.0.camel@johannes.local>
Message-ID: <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com> <1256885343.3555.0.camel@johannes.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Oct 2009, Johannes Berg wrote:

> On Thu, 2009-10-29 at 19:17 -0400, Parag Warudkar wrote:
> > Oct 29 18:59:06 parag-laptop kernel: [  143.180037] wlan0:
> > deauthenticating from 00:16:01:d6:6f:12 by local choice (reason=3)
> > Oct 29 18:59:06 parag-laptop kernel: [  143.181137] wlan0: direct
> > probe to AP 00:16:01:d6:6f:12 (try 1)
> 
> sorry, I can't read this log. please provide a non-wrapped version
> 
How does this look? (Sorry sent it in a rush earlier.)
Below also is a disassembly of cfg80211_conn_work.

Thanks

Parag

OOPS
----
Oct 29 18:59:06 parag-laptop kernel: [  143.181148] wlan0: deauthenticating from 00:16:01:d6:6f:12 by local choice (reason=3)
Oct 29 18:59:06 parag-laptop kernel: [  143.203375] BUG: unable to handle kernel NULL pointer dereference at (null)
Oct 29 18:59:06 parag-laptop kernel: [  143.203432] IP: [<ffffffffa0139161>] cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.203476] PGD 138abc067 PUD 136d87067 PMD 0 
Oct 29 18:59:06 parag-laptop kernel: [  143.203530] Oops: 0000 [#1] SMP 
Oct 29 18:59:06 parag-laptop kernel: [  143.203571] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/controlC1/uevent
Oct 29 18:59:06 parag-laptop kernel: [  143.203597] CPU 0 
Oct 29 18:59:06 parag-laptop kernel: [  143.203629] Modules linked in: aes_generic radeon ttm drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect binfmt_misc snd_hda_codec_atihdmi rfcomm snd_hda_codec_analog sco bnep ppdev l2cap snd_hda_intel arc4 snd_hda_codec snd_pcm_oss snd_mixer_oss snd_hwdep snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn iptable_filter ext3 snd_seq iwlcore snd_timer led_class snd_seq_device ip_tables jbd snd mac80211 psmouse btusb x_tables tpm_infineon soundcore serio_raw bluetooth snd_page_alloc cfg80211 tpm tpm_bios evdev lp parport ext4 mbcache jbd2 fuse ahci libata video output intel_agp e1000e
Oct 29 18:59:06 parag-laptop kernel: [  143.204560] Pid: 9, comm: events/0 Not tainted 2.6.32-rc5 #2 HP EliteBook 8530p
Oct 29 18:59:06 parag-laptop kernel: [  143.204588] RIP: 0010:[<ffffffffa0139161>]  [<ffffffffa0139161>] cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.204634] RSP: 0000:ffff88013f8b5dc0  EFLAGS: 00010246
Oct 29 18:59:06 parag-laptop kernel: [  143.204656] RAX: 0000000000000000 RBX: ffff88013e8db690 RCX: ffff88013cb80118
Oct 29 18:59:06 parag-laptop kernel: [  143.204679] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffff88013e8db690
Oct 29 18:59:06 parag-laptop kernel: [  143.204702] RBP: ffff88013f8b5e30 R08: 0000000000000000 R09: 0000000000000001
Oct 29 18:59:06 parag-laptop kernel: [  143.204724] R10: 0000000000000000 R11: ffff880028295718 R12: ffff88013e8db6b8
Oct 29 18:59:06 parag-laptop kernel: [  143.204747] R13: ffff88013cb800a8 R14: ffff88013cb80000 R15: ffff88013f8b5df0
Oct 29 18:59:06 parag-laptop kernel: [  143.204770] FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.204799] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Oct 29 18:59:06 parag-laptop kernel: [  143.204820] CR2: 0000000000000000 CR3: 000000013dde3000 CR4: 00000000000406f0
Oct 29 18:59:06 parag-laptop kernel: [  143.204843] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.204866] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 29 18:59:06 parag-laptop kernel: [  143.204889] Process events/0 (pid: 9, threadinfo ffff88013f8b4000, task ffff88013f885980)
Oct 29 18:59:06 parag-laptop kernel: [  143.204917] Stack:
Oct 29 18:59:06 parag-laptop kernel: [  143.204936]  ffff88013f8b5dc0 ffff88013f8b5dc0 0000000000000282 ffffffff8162afb8
Oct 29 18:59:06 parag-laptop kernel: [  143.204996] <0> ffff88013cb80018 ffff88013cb80088 ffff880028218040 ffff88013f8b5fd8
Oct 29 18:59:06 parag-laptop kernel: [  143.205085] <0> ffff88013f8b5e10 ffff88013cb80130 ffff880028218040 ffffffffa01390b0
Oct 29 18:59:06 parag-laptop kernel: [  143.205190] Call Trace:
Oct 29 18:59:06 parag-laptop kernel: [  143.205215]  [<ffffffffa01390b0>] ? cfg80211_conn_work+0x0/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.205242]  [<ffffffff8106c86f>] worker_thread+0x17f/0x2c0
Oct 29 18:59:06 parag-laptop kernel: [  143.205265]  [<ffffffff810710d0>] ? autoremove_wake_function+0x0/0x40
Oct 29 18:59:06 parag-laptop kernel: [  143.205289]  [<ffffffff8106c6f0>] ? worker_thread+0x0/0x2c0
Oct 29 18:59:06 parag-laptop kernel: [  143.205311]  [<ffffffff81070cfe>] kthread+0x8e/0xa0
Oct 29 18:59:06 parag-laptop kernel: [  143.205334]  [<ffffffff81012f2a>] child_rip+0xa/0x20
Oct 29 18:59:06 parag-laptop kernel: [  143.205356]  [<ffffffff81070c70>] ? kthread+0x0/0xa0
Oct 29 18:59:06 parag-laptop kernel: [  143.205378]  [<ffffffff81012f20>] ? child_rip+0x0/0x20
Oct 29 18:59:06 parag-laptop kernel: [  143.205399] Code: 63 28 4c 89 e7 e8 c0 02 2b e1 48 8b 43 20 f6 40 48 01 74 c6 83 bb 8c 00 00 00 01 75 bd 48 8b 83 90 00 00 00 48 89 df 48 8b 40 08 <8b> 10 41 89 17 0f b7 40 04 66 41 89 47 04 e8 fc ee ff ff 85 c0 
Oct 29 18:59:06 parag-laptop kernel: [  143.206242] RIP  [<ffffffffa0139161>] cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.206286]  RSP <ffff88013f8b5dc0>
Oct 29 18:59:06 parag-laptop kernel: [  143.206306] CR2: 0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.206327] ---[ end trace ccb079f99bd67991 ]---
Oct 29 18:59:58 parag-laptop kernel: Kernel logging (proc) stopped.

Disassembly
-----------
00000000000140b0 <cfg80211_conn_work>:
   140b0:	55                   	push   %rbp
   140b1:	48 89 e5             	mov    %rsp,%rbp
   140b4:	41 57                	push   %r15
   140b6:	4c 8d 7d c0          	lea    -0x40(%rbp),%r15
   140ba:	41 56                	push   %r14
   140bc:	4c 8d b7 d0 fe ff ff 	lea    -0x130(%rdi),%r14
   140c3:	41 55                	push   %r13
   140c5:	4d 8d ae a8 00 00 00 	lea    0xa8(%r14),%r13
   140cc:	41 54                	push   %r12
   140ce:	53                   	push   %rbx
   140cf:	48 89 fb             	mov    %rdi,%rbx
   140d2:	48 83 ec 48          	sub    $0x48,%rsp
   140d6:	e8 00 00 00 00       	callq  140db <cfg80211_conn_work+0x2b>
   140db:	49 8d 46 18          	lea    0x18(%r14),%rax
   140df:	48 89 c7             	mov    %rax,%rdi
   140e2:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
   140e6:	e8 00 00 00 00       	callq  140eb <cfg80211_conn_work+0x3b>
   140eb:	49 8d 86 88 00 00 00 	lea    0x88(%r14),%rax
   140f2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   140f6:	48 89 c7             	mov    %rax,%rdi
   140f9:	e8 00 00 00 00       	callq  140fe <cfg80211_conn_work+0x4e>
   140fe:	48 8b 9b 78 ff ff ff 	mov    -0x88(%rbx),%rbx
   14105:	48 83 eb 10          	sub    $0x10,%rbx
   14109:	eb 15                	jmp    14120 <cfg80211_conn_work+0x70>
   1410b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   14110:	4c 89 e7             	mov    %r12,%rdi
   14113:	e8 00 00 00 00       	callq  14118 <cfg80211_conn_work+0x68>
   14118:	48 8b 5b 10          	mov    0x10(%rbx),%rbx
   1411c:	48 83 eb 10          	sub    $0x10,%rbx
   14120:	48 8b 43 10          	mov    0x10(%rbx),%rax
   14124:	0f 18 08             	prefetcht0 (%rax)
   14127:	48 8d 43 10          	lea    0x10(%rbx),%rax
   1412b:	49 39 c5             	cmp    %rax,%r13
   1412e:	0f 84 7c 00 00 00    	je     141b0 <cfg80211_conn_work+0x100>
   14134:	4c 8d 63 28          	lea    0x28(%rbx),%r12
   14138:	4c 89 e7             	mov    %r12,%rdi
   1413b:	e8 00 00 00 00       	callq  14140 <cfg80211_conn_work+0x90>
   14140:	48 8b 43 20          	mov    0x20(%rbx),%rax
   14144:	f6 40 48 01          	testb  $0x1,0x48(%rax)
   14148:	74 c6                	je     14110 <cfg80211_conn_work+0x60>
   1414a:	83 bb 8c 00 00 00 01 	cmpl   $0x1,0x8c(%rbx)
   14151:	75 bd                	jne    14110 <cfg80211_conn_work+0x60>
   14153:	48 8b 83 90 00 00 00 	mov    0x90(%rbx),%rax
   1415a:	48 89 df             	mov    %rbx,%rdi
   1415d:	48 8b 40 08          	mov    0x8(%rax),%rax
   14161:	8b 10                	mov    (%rax),%edx
   14163:	41 89 17             	mov    %edx,(%r15)
   14166:	0f b7 40 04          	movzwl 0x4(%rax),%eax
   1416a:	66 41 89 47 04       	mov    %ax,0x4(%r15)
   1416f:	e8 fc ee ff ff       	callq  13070 <cfg80211_conn_do_work>
   14174:	85 c0                	test   %eax,%eax
   14176:	74 98                	je     14110 <cfg80211_conn_work+0x60>
   14178:	48 8b 7b 20          	mov    0x20(%rbx),%rdi
   1417c:	45 31 c9             	xor    %r9d,%r9d
   1417f:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
   14186:	00 00 
   14188:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
   1418f:	00 
   14190:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
   14197:	45 31 c0             	xor    %r8d,%r8d
   1419a:	31 c9                	xor    %ecx,%ecx
   1419c:	31 d2                	xor    %edx,%edx
   1419e:	4c 89 fe             	mov    %r15,%rsi
   141a1:	e8 00 00 00 00       	callq  141a6 <cfg80211_conn_work+0xf6>
   141a6:	e9 65 ff ff ff       	jmpq   14110 <cfg80211_conn_work+0x60>
   141ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   141b0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
   141b4:	e8 00 00 00 00       	callq  141b9 <cfg80211_conn_work+0x109>
   141b9:	49 81 fe 00 f0 ff ff 	cmp    $0xfffffffffffff000,%r14
   141c0:	77 27                	ja     141e9 <cfg80211_conn_work+0x139>
   141c2:	4d 85 f6             	test   %r14,%r14
   141c5:	74 22                	je     141e9 <cfg80211_conn_work+0x139>
   141c7:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
   141cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   141d0:	e8 00 00 00 00       	callq  141d5 <cfg80211_conn_work+0x125>
   141d5:	e8 00 00 00 00       	callq  141da <cfg80211_conn_work+0x12a>
   141da:	48 83 c4 48          	add    $0x48,%rsp
   141de:	5b                   	pop    %rbx
   141df:	41 5c                	pop    %r12
   141e1:	41 5d                	pop    %r13
   141e3:	41 5e                	pop    %r14
   141e5:	41 5f                	pop    %r15
   141e7:	c9                   	leaveq 
   141e8:	c3                   	retq   
   141e9:	0f 0b                	ud2a   
   141eb:	eb fe                	jmp    141eb <cfg80211_conn_work+0x13b>
   141ed:	0f 1f 00             	nopl   (%rax)

