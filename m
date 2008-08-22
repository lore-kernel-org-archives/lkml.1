Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYHVPfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYHVPfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYHVPez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:34:55 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49178 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYHVPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:34:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAIN5rkhMRKxB/2dsb2JhbACBZbR3gWg
Date: Fri, 22 Aug 2008 11:34:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822153451.GA8390@Krystal>
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com> <48AE5FCF.6030103@zytor.com> <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080822113941.147a1db0@doriath.conectiva>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:30:15 up 78 days, 20:10,  7 users,  load average: 0.26, 0.73,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> Em Fri, 22 Aug 2008 08:50:12 +0200
> Ingo Molnar <mingo@elte.hu> escreveu:
> 
> | 
> | * H. Peter Anvin <hpa@zytor.com> wrote:
> | 
> | > H. Peter Anvin wrote:
> | >>>
> | >>>  Does this look like a kernel bug?
> | >>>
> | >>
> | >> No, it looks like a very common virtualizer bug.  Does the attached  
> | >> patch work for you?
> | >>
> | >
> | > Also, in addition to this, please try tip:master.  There is a patch in 
> | > tip:master which I hope should fix this problem, but the details are 
> | > important.
> | 
> | access coordinates would be at:
> | 
> |   http://people.redhat.com/mingo/tip.git/README
> 
>  As I already have Linus tree downloaded I have cloned it in
> the usual way.
> 
>  Got the same results: OOPS in virtualbox but it works on QEMU.
> 
>  The OOPS's output follows and I have attached the .config I'm using
> to reproduce the problem.
> 

Can you try booting with the kernel argument :
  debug_alternative 

The dmesg of the kernel bootup up to the oops would be helpful.

My guess is that there may be something wrong with irq disabling which
protects text_poke_early in apply_alternatives().

Mathieu


> """
> BUG: unable to handle kernel NULL pointer dereference at 00000246
> IP: [<c01310f1>] vprintk+0x181/0x440
> *pde = 00000000 
> Oops: 0002 [#1] SMP 
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted (2.6.27-rc4-test24-tip #3)
> EIP: 0060:[<c01310f1>] EFLAGS: 00010246 CPU: 0
> EIP is at vprintk+0x181/0x440
> EAX: 00000246 EBX: 00000000 ECX: c0130ca9 EDX: 0000dedd
> ESI: c0474ae3 EDI: c04cf6bc EBP: c7435f24 ESP: c7435eb0
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> Process swapper (pid: 1, ti=c7434000 task=c7438000 task.ti=c7434000)
> Stack: 0000dedd c0130ca9 c7435f40 00000000 a026104f a026106c c7434000 c7435ee6 
>        00000006 00000246 00000000 a0260cf3 0000001c c7434000 00000282 00000046 
>        c11a85a0 c7435efc c0135c6f c7435f14 c0115fcb a0296e91 c0104c2c 00000000 
> Call Trace:
>  [<c0130ca9>] ? release_console_sem+0x199/0x1e0
>  [<c0135c6f>] ? irq_exit+0x3f/0x90
>  [<c0115fcb>] ? smp_apic_timer_interrupt+0x5b/0x90
>  [<c0104c2c>] ? apic_timer_interrupt+0x28/0x30
>  [<c0474ae3>] ? net_ns_init+0x0/0x1ad
>  [<c0474ae3>] ? net_ns_init+0x0/0x1ad
>  [<c0346ed9>] ? printk+0x18/0x1f
>  [<c0474b00>] ? net_ns_init+0x1d/0x1ad
>  [<c0474ae3>] ? net_ns_init+0x0/0x1ad
>  [<c0101116>] ? do_one_initcall+0x26/0x170
>  [<c0128f66>] ? try_to_wake_up+0xc6/0x240
>  [<c012910f>] ? wake_up_process+0xf/0x20
>  [<c014192d>] ? start_workqueue_thread+0x1d/0x20
>  [<c0141d4b>] ? __create_workqueue_key+0x1eb/0x240
>  [<c0141820>] ? worker_thread+0x0/0xf0
>  [<c044b387>] ? kernel_init+0x141/0x214
>  [<c044b246>] ? kernel_init+0x0/0x214
>  [<c0104dc7>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: c0 0f 84 0b 01 00 00 b8 50 f1 41 c0 c7 05 ec f1 41 c0 ff ff ff ff e8 cf 8b 21 00 e8 ea 04 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 8b 45 bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 ec f1 41 c0 e8 
> EIP: [<c01310f1>] vprintk+0x181/0x440 SS:ESP 0069:c7435eb0
> ---[ end trace 4eaa2a86a8e2da22 ]---
> """
> 
> -- 
> Luiz Fernando N. Capitulino



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
