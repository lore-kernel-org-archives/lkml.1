Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXFAC1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXFAC1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXFAC0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:26:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:36798 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXFAC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rbKGAgRD8Uer06ODDeBPjOuVkauKJWFV+s03zgDS9/GE5MvB6r5EsDnoXo1B1luNGFNbCTFtaQOSt18iB2rhO+NSXUSlTZGJkrXKvfDT3pEcLeIFpmcntx4tP5NUNiZsjuKftrx+z1d+LiCyer5aNddKi4rfReXPKg58GwBbwlw=
Message-ID: <a8e1da0705311926n95c6913iea04b240812dfdfd@mail.gmail.com>
Date: Fri, 1 Jun 2007 02:26:51 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch -mm] alsa mixer_oss kfree fix
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
In-Reply-To: <a8e1da0705311921v8bdec77vaa918efd9910e51b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
	 <20070531191005.292efbdc.akpm@linux-foundation.org>
	 <a8e1da0705311921v8bdec77vaa918efd9910e51b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Just append to my email.

The reason I read mixer_oss.c is that I see oops in 2.6.22-rc1-mm1,
seems oops in mixer_oss.c, but the oops rised only once, I found
rc3-mm1 have no change in this file,
so I read the source , then post this patch.

please find the oops message below:


BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000088
 printing eip:
c0162bc2
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: snd_mixer_oss snd_hda_intel snd_pcm snd_timer
snd_page_alloc snd soundcore ipv6 capability commoncap e100 mi
i agpgart pcspkr psmouse
CPU:    0
EIP:    0060:[<c0162bc2>]    Not tainted VLI
EFLAGS: 00010087   (2.6.22-rc1-mm1 #7)
EIP is at kfree+0x42/0x90
eax: 00000000   ebx: c10568e0   ecx: c2b47000   edx: c01588d2
esi: 00000287   edi: 00000000   ebp: c2864000   esp: c2865f58
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process modprobe (pid: 2963, ti=c2864000 task=c1ede540 task.ti=c2864000)
Stack: 00000011 f8855000 c0520cb4 00000001 00000001 c1e524a0 c1051bc0 c01588d2
       0805c348 00000001 c2864000 f885502b f8840a00 00000000 00000001 c013caf1
       00004b79 00000000 000b7f68 00000000 b7f44840 08065f88 0805c348 c01040bc
Call Trace:
 [<f8855000>] alsa_mixer_oss_init+0x0/0x37 [snd_mixer_oss]
 [<c01588d2>] __vunmap+0xb2/0xe0
 [<f885502b>] alsa_mixer_oss_init+0x2b/0x37 [snd_mixer_oss]
 [<c013caf1>] sys_init_module+0xa1/0x140
 [<c01040bc>] syscall_call+0x7/0xb
 [<c0440000>] packet_seq_start+0x30/0x60
 =======================
Code: 00 00 00 40 a1 40 6a 59 c0 c1 ea 0c c1 e2 05 01 c2 8b 02 89 d3
25 00 40 02 00 3d 00 40 02 00 74 45 8b 7b 10 8b 54 24 1c 9
c 5e fa <39> 9f 88 00 00 00 75 25 8b 03 a8 02 75 1f 0f b7 53 0a 8b 43 0c
EIP: [<c0162bc2>] kfree+0x42/0x90 SS:ESP 0068:c2865f58
