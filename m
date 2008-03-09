Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYCIXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYCIXEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYCIXEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:04:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:3528 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYCIXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=h5zv02TM6RoJfQLQOGxaty7+4b8Ax0nO+NpbtAci4316ivQwUHtpBEjFiMZhcOmh/1xp3pAuV00iUvAhrslW4ezD6VkCog1jZgrTsCpWynL+GzE4JpAqUdvKiBvHaAklRse+yIUgyDa0uXlkQzGRMauCbisjFYILKMygFCWM2z8=
Message-ID: <47D46D04.60300@gmail.com>
Date: Mon, 10 Mar 2008 00:04:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] drivers/char/esp.c: fix bootup lockup
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080307100806.GA4350@elte.hu> <47D3E8ED.6070404@gmail.com> <200803092349.45972.rjw@sisk.pl>
In-Reply-To: <200803092349.45972.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2008 11:49 PM, Rafael J. Wysocki wrote:
> On Sunday, 9 of March 2008, Jiri Slaby wrote:
>> On 03/07/2008 11:08 AM, Ingo Molnar wrote:
>>> randconfig testing found a bootup lockup in drivers/char/esp.c - find 
>>> the fix below. Not sure why it became more prominent in 2.6.25-rc4, the 
>>> bug seems rather old and i've been doing allyesconfig bootups for ages 
>>> with CONFIG_ESP enabled.
>>>
>>> ------------->
>>> Subject: drivers/char/esp.c: fix bootup lockup
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Fri Mar 07 10:47:43 CET 2008
>>>
>>> fix this bootup lockup:
>>>
>>>  PM: Adding info for No Bus:ttyP63
>>>  ttyP32 at 0x0240 (irq = 0) is an ESP primary port
>>>  BUG: spinlock lockup on CPU#0, swapper/1, f56dd004
>>>  Pid: 1, comm: swapper Not tainted 2.6.25-rc4-sched-devel.git-x86-latest.git #402 [<c03ac6f4>] _raw_spin_lock+0x134/0x140
>>>   [<c08649be>] _spin_lock_irqsave+0x5e/0x80
>>>   [<c0b9fbfe>] ? espserial_init+0x2be/0x6e0
>>>   [<c0b9fbfe>] espserial_init+0x2be/0x6e0
>>>   [<c0b877a3>] kernel_init+0x83/0x260
>>>   [<c0b9f940>] ? espserial_init+0x0/0x6e0
>>>   [<c010416a>] ? restore_nocheck_notrace+0x0/0xe
>>>   [<c0b87720>] ? kernel_init+0x0/0x260
>>>   [<c0b87720>] ? kernel_init+0x0/0x260
>>>   [<c0104507>] kernel_thread_helper+0x7/0x10
>>>   =======================
>>>
>>> kzalloc() is not the way to initialize spinlocks anymore.
>> Good catch, thanks.
> 
> Is this a regression from 2.6.24?

I don't think so, the init code hasn't been touched for years...

regards,
--js
