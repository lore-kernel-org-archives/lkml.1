Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZDLNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZDLNMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZDLNMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:12:06 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51745 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZDLNMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qEX8oAiNv+/Z7LNTeOocbDYh4XpyNUkzJBLk1YRRGogjzCmGxfAALZBgdAwdAaWAFG
         bUaZDxO727BFbKfdnzww9D+b9hDuft6+7v0h2WUYOnf/o0a53ld4HdlgSmpDnz2mOPLs
         rXq1hbadC2z1enJ3po+i+arWXFT04pPtOgao8=
Message-ID: <49E1E89D.7040502@tuffmail.co.uk>
Date: Sun, 12 Apr 2009 14:11:57 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [BISECTED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <66dc75180904111107q645fbb77i3cf927ffab7a7ef0@mail.gmail.com> <49E1ADAE.2030103@tuffmail.co.uk>
In-Reply-To: <49E1ADAE.2030103@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Tzy-Jye Daniel Lin wrote:
>   
>> On Sat, Apr 11, 2009 at 5:41 AM, Alan Jenkins
>> <alan-jenkins@tuffmail.co.uk> wrote:
>>   
>>     
>>> Regression #6 on latest git! (last known good is 2.6.29-rc8)
>>>
>>> Magic SysRQ keys work though.  Unfortunately, SysRq-W / SysRq-T generate
>>> too much output, so the useful bits immediately scroll off the top of
>>> the screen.  I can't press SysRq-P (even if that would help), because
>>> the SysRQ key on my laptop is accessed using a Fn modifier key, which
>>> also turns the left hand side of the keyboard into a numeric pad.
>>>     
>>>       
>> I don't own an Eee, but having played with one, the key sequence
>>
>>     Alt down
>>     Fn down
>>     SysRq down, up
>>     Fn up
>>     P down, up
>>     Alt up
>>
>> should work just fine.  As long as you keep holding Alt, you don't
>> need to continue holding SysRq after the initial keypress.
>>
>>   
>>     
>>> Magic SysRQs on my USB keyboard generate no response.  (Sometimes the
>>> numlock key seems to work though.  I can't tell on the laptop keyboard
>>> because the laptop doesn't have a numlock led).
>>>     
>>>       
>> SysRq over USB has never worked.  On PC hardware, Magic SysRq depends
>> on features of the built-in i8042 controller, which only handles PS/2
>> input.
>>   
>>     
> Great, thanks a lot!
>
> I was able to run SysRq-P, and found the following backtrace -
>
> Pid: 0
> EIP is at acpi_idle_enter_bm+0x1df/0x208 [processor]
> cpud_idle_call
> cpu_idle
> rest_init
> start_kernel
> i386_start_kernel
>   

7ec0a7290797f57b780f792d12f4bcc19c83aa4f is first bad commit
commit 7ec0a7290797f57b780f792d12f4bcc19c83aa4f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Mar 30 17:48:24 2009 +0000

    ACPI: processor: use .notify method instead of installing handler
directly

    This patch adds a .notify() method.  The presence of .notify() causes
    Linux/ACPI to manage event handlers and notify handlers on our behalf,
    so we don't have to install and remove them ourselves.

    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Zhang Rui <rui.zhang@intel.com>
    CC: Zhao Yakui <yakui.zhao@intel.com>
    CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>
    CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>



However, reverting this commit from v2.6.30-rc1 doesn't solve the hang.

Alan
