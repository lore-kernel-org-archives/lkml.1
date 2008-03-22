Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYCVKwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYCVKwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 06:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYCVKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 06:51:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:49586 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYCVKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 06:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=c3Q7lWyB2MO1pW5ce8PQ83o95AeF03D+KHqHaGnrNwES4biwoAYNVBBU1oIKuULcDACt2mxk3dvyP3J1EI/zG8OVk6RiLj0JRZRlaxGurWLbBomJPpBO7SV1Keo2peWEkv7yNjhxu1xNeaUuV4Oo+/6DPuGjHUiRQFQ3N7CEiYs=
Message-ID: <47E4E4AE.6030308@gmail.com>
Date: Sat, 22 Mar 2008 11:51:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sudheer Divakaran <sudheerd@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: enabling serial port caused kernel crash in an old pc
References: <211620.40633.qm@web54504.mail.re2.yahoo.com>
In-Reply-To: <211620.40633.qm@web54504.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2008 07:47 AM, Sudheer Divakaran wrote:
> Hi,
> I have an old pc (Intel P2 400 MHz, 128MB), which has
> FC5 installed in
> it.  I was trying to compile & install the kernel
> 2.6.24.3. I have
> succeeded in bringing up the kernel without serial
> port support.  Since
> I'm still using serial mouse, I have added serial
> ports  support and
> recompiled the kernel. When I'm booting with this
> kernel (having serial
> port support), it is crashing (while booting itself).
> 
> Here is the crash dump (I have written it down), I
> might have missed
> some starting lines since it has scrolled up
> 
> sysfs_create_link
> pciserial_init_one
> pci_device_probe
> driver_probe_device
> klist_next
> __driver_attach
> bus_for_each_dev
> __driver_attach
> bus_add_driver
> bus_add_driver
> __pci_register_driver
> kernel_init
> kernel_init
> kernel_thread_helper
> ==============================
> 
> serial_pci_guess_board+0x49/0x170 SS:ESP 0068:c7c11ea4
> 
> Code: 03 07 00 00 74 0b b8 ed ff ff ff 5a 5b 5e 5f 5d
> c3 25 ff 00 00 00
>      83 f8 06 77 eb 0f b7 4e 24 31 d2 eb 08 83 c2 1c
> 83 fa 34 74 1c <3b>
>  8a 1c 29 2b c0 75 f0 0f b7 46 26 3b 82 20 29 2b c0 74
> c7 83

confused.
   1f:   31 d2                   xor    %edx,%edx
   21:   eb 08                   jmp    2b <p+0x2b>
   23:   83 c2 1c                add    $0x1c,%edx
   26:   83 fa 34                cmp    $0x34,%edx
   29:   74 1c                   je     47 <p+0x47>
   2b:   3b 8a 1c 29 2b c0       cmp    -0x3fd4d6e4(%edx),%ecx

What's the compiler used here? How can edx be ever 0x34 if the increment is 
0x1c? What's in edx when the crash occurs, could you see it in the oops? Are you 
sure you didn't mistype it? Maybe a shot from camera would be good...

I suppose c02b291b is softmodem_blacklist in System.map?

Could you send
drivers/serial/8250_pci.s
product of:
make drivers/serial/8250_pci.s
?
