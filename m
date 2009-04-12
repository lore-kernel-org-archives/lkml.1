Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZDLJAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZDLJAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZDLJAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 05:00:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:20501 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZDLJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 05:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lQ4/al3RmNPrLcYaWeGnJ4IpThA/2BRCDIOlg8RbvBTY48Zp8rQB23Ua5HanZvHh7C
         ljAe907Fk3abpUs8ddH7hwoYsk7Q2U2nDuYsIwBh+Tfp6Ia5BGoQqTeZm1J+lmmlg85I
         ZKFcD6AnZOVIbDjrga80tA4N8n/EHrJrR81Zg=
Message-ID: <49E1ADAE.2030103@tuffmail.co.uk>
Date: Sun, 12 Apr 2009 10:00:30 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Tzy-Jye Daniel Lin <ephemient@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Regression: EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <66dc75180904111107q645fbb77i3cf927ffab7a7ef0@mail.gmail.com>
In-Reply-To: <66dc75180904111107q645fbb77i3cf927ffab7a7ef0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tzy-Jye Daniel Lin wrote:
> On Sat, Apr 11, 2009 at 5:41 AM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:
>   
>> Regression #6 on latest git! (last known good is 2.6.29-rc8)
>>
>> Magic SysRQ keys work though.  Unfortunately, SysRq-W / SysRq-T generate
>> too much output, so the useful bits immediately scroll off the top of
>> the screen.  I can't press SysRq-P (even if that would help), because
>> the SysRQ key on my laptop is accessed using a Fn modifier key, which
>> also turns the left hand side of the keyboard into a numeric pad.
>>     
>
> I don't own an Eee, but having played with one, the key sequence
>
>     Alt down
>     Fn down
>     SysRq down, up
>     Fn up
>     P down, up
>     Alt up
>
> should work just fine.  As long as you keep holding Alt, you don't
> need to continue holding SysRq after the initial keypress.
>
>   
>> Magic SysRQs on my USB keyboard generate no response.  (Sometimes the
>> numlock key seems to work though.  I can't tell on the laptop keyboard
>> because the laptop doesn't have a numlock led).
>>     
>
> SysRq over USB has never worked.  On PC hardware, Magic SysRq depends
> on features of the built-in i8042 controller, which only handles PS/2
> input.
>   
Great, thanks a lot!

I was able to run SysRq-P, and found the following backtrace -

Pid: 0
EIP is at acpi_idle_enter_bm+0x1df/0x208 [processor]
cpud_idle_call
cpu_idle
rest_init
start_kernel
i386_start_kernel


