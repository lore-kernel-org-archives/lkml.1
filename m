Return-Path: <linux-kernel-owner+w=401wt.eu-S965092AbXA3PyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbXA3PyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965286AbXA3PyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:54:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:8094 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbXA3PyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HxCnycBq7kXOJyB3CVawuwsuDo3px1GkiQ2TeWk7wkDxvLD3tSKNWgVCOkRZhirUJsqP76P7tYlU6kQ9gLYLHb2lD2IkNKzS8Hm+OmB7uaDUNZm/hPjQBhcFSPw3bsyI5RjzJLOCINJtyAyNtTeVkZJwBYYerjJPuKprPOUrX5Q=
Message-ID: <3efb10970701300753s2ca7e0ebnf913d85b160c7adf@mail.gmail.com>
Date: Tue, 30 Jan 2007 16:53:59 +0100
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Henri Hunnekens" <henrihunnekens@gmail.com>
Subject: Re: [ OOPS ] at do_futex with 2.6.20-RC5-RT10
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e9f486400701300410l479cde02jc916ccde81163f8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9f486400701300410l479cde02jc916ccde81163f8c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henri,

I have seen similar problems...
I do not know yet what caused it...

Remy

2007/1/30, Henri Hunnekens <henrihunnekens@gmail.com>:
> Dear Ingo,
>
> I've an made an application which causes an OOPS using kernel version
> 2.6.20-RC5-RT10 ( also seen with older verison 2.6.19.1-rt15 ) + FC6
> userland.
>
> The application periodically calls the libc system() routine. The
> system() routine just calls a simple external bash script. The
> application is a SCHED_OTHER application with PI mutexes. I think that
> the problem is caused by the system() routine.
>
> The following is a dump of the stdout made with kernel version
> 2.6.19.1-rt15. But 2.6.20-RC5-RT10 has the same problem.
>
>
> Oops: 0003 [#1]
> PREEMPT SMP
> Modules linked in: cap_over commoncap i2c_dev uhci_hcd i2c_i801 i2c_core ehci_hc
> d
> CPU:    0
> EIP:    0060:[<c0141d9c>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.19.1-rt15 #1)
> EIP is at do_futex+0x8ec/0xfb0
> eax: 0000081f   ebx: 0000081f   ecx: 08511a28   edx: 00000000
> esi: 8000081f   edi: dc3e7fa0   ebp: dc3e7f7c   esp: dc3e7e38
> ds: 007b   es: 007b   ss: 0068   preempt: 00000002
> Process SSL_Linux (pid: 2079, ti=dc3e6000 task=df6bd000 task.ti=dc3e6000)
> Stack: dc3e7eac c05a6570 00000278 00000001 6e6a32ae 00000000 c05a74e0 00000000
>        15c1f019 00000277 0000086f 00000000 c16ecaa0 04000001 c05a7360 00000000
>        c16ecaa0 00000086 df6ad550 dc3e6000 00000000 fffffff2 c05a7de0 df6ad550
> Call Trace:
>  [<c01054e6>] show_trace_log_lvl+0x26/0x40
>  [<c01055b1>] show_stack_log_lvl+0xb1/0xe0
>  [<c01059ef>] show_registers+0x1cf/0x280
>  [<c0105bdf>] die+0x13f/0x320
>  [<c0119a7c>] do_page_fault+0x21c/0x660
>  [<c04252e9>] error_code+0x39/0x40
>  [<c01424ff>] sys_futex+0x9f/0xd0
>  [<c01047ad>] sysenter_past_esp+0x56/0x79
>  =======================
> Code: 08 8b 9a b0 00 00 00 83 c1 04 19 d2 39 48 18 83 da 00 85 d2 b9 01 00 00 00
>  c7 85 10 ff ff ff f2 ff ff ff 75 17 89 d8 8b 4d 08 90 <0f> b1 11 31 c9 83 f8 f2
>  89 85 10 ff ff ff 0f 94 c1 89 e0 25 00
>
> Do you have any idea what causes this problem or how to find out?
>
> Best regards,
> Henri Hunnekens
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
