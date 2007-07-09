Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbXGIHPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbXGIHPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXGIHPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:15:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54769 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXGIHPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bS33ODFHzzuY4oqsXfrIcGh8GdS36CRsSxZuSCbUGHlSySyJm2WWlrWiizHlFhrogfXCAjzHqKhVAnfr4dHmVDPqsGytlINDZUZX1cXXP2KJA0kYDITBtnojsCIDWxIKyBdhm6z9WZdhQp1KtpAJEX1/BIehaxWzPc7BHyt3MGg=
Message-ID: <4691E08F.4050908@gmail.com>
Date: Mon, 09 Jul 2007 09:15:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sasa Ostrouska <casaxa@gmail.com>, linux-kernel@vger.kernel.org,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net
Subject: Re: KVM-AMD OOPS
References: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com> <4691BF62.2060207@goop.org>
In-Reply-To: <4691BF62.2060207@goop.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge napsal(a):
> Sasa Ostrouska wrote:
>> root@rcserver:~# modprobe kvm-amd
>> int3: 0000 [1] PREEMPT SMP
>> CPU 1
>> Modules linked in: kvm_amd snd_seq_dummy snd_seq_oss
>> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
>> nls_iso8859_1 ntfs nls_base usb_storage libusual capability commoncap
>> lp psmouse snd_hda_intel snd_hda_codec snd_pcm snd_timer ohci_hcd
>> ehci_hcd 8139too rtc_cmos snd soundcore snd_page_alloc usbcore k8temp
>> mii rtc_core rtc_lib i2c_nforce2 parport_pc parport
>> Pid: 2898, comm: modprobe Tainted: P       2.6.21.5 #1
>> RIP: 0010:[<ffffffff80572364>]  [<ffffffff80572364>]
>> register_cpu_notifier+0x1/0x31
>> RSP: 0000:ffff81006e34df40  EFLAGS: 00000246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000c0010117
>> RDX: 000000000000ffff RSI: ffff81006e219640 RDI: ffffffff80536510
>> RBP: ffffffff880d8840 R08: 0000000000000000 R09: 000000000006b5f4
>> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000005296b0
>> R13: 00007fff51fe55c0 R14: 0000000000000000 R15: 0000000000000000
>> FS:  00002b4e58e18b00(0000) GS:ffff810002e794c0(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 000000000050df64 CR3: 000000007a0f3000 CR4: 00000000000006e0
>> Process modprobe (pid: 2898, threadinfo ffff81006e34c000, task
>> ffff81007bc48400)
>> Stack:  ffffffff8039e024 ffff81006e34c000 ffffffff880d8840
>> 0000000000005e19
>> ffffffff8024537c 0000000000000000 00007fff51fe50c0 00000000004142d0
>> ffffffff8020967e 0000000000000206 00000000005230e0 000000000052f4c9
>> Call Trace:
>> [<ffffffff8039e024>] kvm_init_arch+0x90/0x145
>> [<ffffffff8024537c>] sys_init_module+0xad/0x168
>> [<ffffffff8020967e>] system_call+0x7e/0x83
>>
>>
>> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> 
> This is the init section poison pattern.  Looks like an init function
> was used after the code was freed.

This?
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=65edc68c345cbe21d0b0375c3452a3ed5e322868;hp=054cc8a2d808822dadf488a61729e3e550f114c4

Could you revert it and test?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
