Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbXGHRmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbXGHRmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXGHRmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:42:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:12873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXGHRmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=PlFaLOPFvS7UizOTGz6uJ3mphCCah3CWYyF8RBx4X0zHMRws/YCJqnadhfxUMlrU6zTy0suNUnXZi22VP4sB4uGtpAsjtoVDJezVLXRuijBlg2nrcTVLNzReXNKUbNnpH36YinsmhyDAxbs37lWrobMsquBC4RWnji/wQ8Bb4Pg=
Message-ID: <469121DC.7070504@googlemail.com>
Date: Sun, 08 Jul 2007 19:41:48 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: KVM-AMD OOPS
References: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com>
In-Reply-To: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sasa Ostrouska pisze:
> Hi people,
> 
> I have kernel 2.6.21.5 and when trying to insert the kvm-amd module I
> get this oops:
> 
> root@rcserver:~# modprobe kvm-amd
> int3: 0000 [1] PREEMPT SMP
> CPU 1
> Modules linked in: kvm_amd snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
> nls_iso8859_1 ntfs nls_base usb_storage libusual capability commoncap
> lp psmouse snd_hda_intel snd_hda_codec snd_pcm snd_timer ohci_hcd
> ehci_hcd 8139too rtc_cmos snd soundcore snd_page_alloc usbcore k8temp
> mii rtc_core rtc_lib i2c_nforce2 parport_pc parport
> Pid: 2898, comm: modprobe Tainted: P       2.6.21.5 #1

"When you are using a binary driver, the kernel is ”tainted”, which means that the source
of possible problems may be unrelated to the kernel code
(see https://secure-support.novell.com/KanisaPlatform/Publishing/250/3582750f.SAL_Public.html
for more details). You can check whether or not the kernel was tainted when the problem occurred by
looking at the corresponding error message. If can you see something similar to the following line:
EIP:      0060:[<c046c7c3>]         Tainted: P      VLI
(the word Tainted is crucial here), the kernel was tainted and most probably the kernel
developers will not be able to help you. In that case you should try to reproduce the problem
without the binary driver loaded. Moreover, if the problem does not occur without it, you
should send a bug report to the creators of the binary driver and ask them to fix it."

-- Linux Kernel Tester’s Guide

> RIP: 0010:[<ffffffff80572364>]  [<ffffffff80572364>]
> register_cpu_notifier+0x1/0x31
> RSP: 0000:ffff81006e34df40  EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000c0010117
> RDX: 000000000000ffff RSI: ffff81006e219640 RDI: ffffffff80536510
> RBP: ffffffff880d8840 R08: 0000000000000000 R09: 000000000006b5f4
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000005296b0
> R13: 00007fff51fe55c0 R14: 0000000000000000 R15: 0000000000000000
> FS:  00002b4e58e18b00(0000) GS:ffff810002e794c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000050df64 CR3: 000000007a0f3000 CR4: 00000000000006e0
> Process modprobe (pid: 2898, threadinfo ffff81006e34c000, task
> ffff81007bc48400)
> Stack:  ffffffff8039e024 ffff81006e34c000 ffffffff880d8840 0000000000005e19
> ffffffff8024537c 0000000000000000 00007fff51fe50c0 00000000004142d0
> ffffffff8020967e 0000000000000206 00000000005230e0 000000000052f4c9
> Call Trace:
> [<ffffffff8039e024>] kvm_init_arch+0x90/0x145
> [<ffffffff8024537c>] sys_init_module+0xad/0x168
> [<ffffffff8020967e>] system_call+0x7e/0x83
> 
> 
> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> RIP  [<ffffffff80572364>] register_cpu_notifier+0x1/0x31
> RSP <ffff81006e34df40>
> note: modprobe[2898] exited with preempt_count 1
> Segmentation fault
> 
> Message from syslogd@rcserver at Sun Jul  8 21:00:33 2007 ...
> rcserver kernel: int3: 0000 [1] PREEMPT SMP
> root@rcserver:~#
> 
> This is on a x86-64 machine. If you need additional info please
> contact by e-mail as i'm not subscribed to the list.
> 
> Best Regards
> Sasa Ostrouska
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
