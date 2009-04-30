Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbZD3Aey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbZD3Aey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762310AbZD3Acu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:32:50 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33874 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1762323AbZD3Act convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:32:49 -0400
Message-ID: <441051630.11976@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: ylmao@mail.ustc.edu.cn
From: "Mao Yilu" <ylmao@mail.ustc.edu.cn>
To: "'Robert Hancock'" <hancockrwd@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <440758024.12507@ustc.edu.cn> <441049102.10204@ustc.edu.cn>
Subject: RE: TSC unstable on Intel Pentium M processor 750
Date: Thu, 30 Apr 2009 08:32:30 +0800
Message-ID: <654E14825BCE4C9B94E5986000DC9BCE@xiaomao>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <441049102.10204@ustc.edu.cn>
Thread-Index: AcnJJXH6JMvs8fHlSd2vOwOC1XohPAABZqJQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply.
But I still don't know why the TSC is not correct in the C1 state (hlt instruction). Is there anything more to influence the TSC? What happened when the CPU is not running under hlt instruction?

Thank you.
Mao Yilu

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Robert Hancock
Sent: Thursday, April 30, 2009 7:50 AM
To: Mao Yilu
Cc: linux-kernel@vger.kernel.org
Subject: Re: TSC unstable on Intel Pentium M processor 750

Mao Yilu wrote:
> Hi,
> 
> I masked all the interrupts except keyboard interrupt before the instruction “hlt”, So the CPU ran nothing until I click the keyboard button. And I used “rdtscll” and “do_gettimeofday” to get the halt time. But the result of “do_gettimeofday” was longer than the one of “rdtscll” about 3s per minute. I don’t know why.
> I timed some math job using the same way in contrary to the “hlt” instruction. The TSC was not correct either. In 3 minutes, the result of “do_gettimeofday” was longer than the one of “rdtscll” about 5s.
> The processor is Intel Pentium M processor 750. From the software developer’s manual of Intel, the processor clock of Pentium M processors is impacted by Intel SpeedStep technology, while some other processors is not. Maybe this is another feature Pentium M processors own.
> Pentium M processors support 5 C-states. I am sure the TSC doesn’t stop in C0 and C1 states. But I am not sure about other states. Maybe other states will stop the clock, and “hlt” instruction will make the CPU into deeper state.
> These are my guess. I wanna the truth. Thank you.
> 
> Mao Yilu
> 

On many processors the TSC will stop in various C-states, and also the 
TSC frequency changes when CPU frequency changes. This is why using 
rdtsc in userspace is not reliable, since the code can't know whether or 
not TSC can be used on that CPU reliably or how to scale the results.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

