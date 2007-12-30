Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXL3SWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXL3SWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXL3SWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:22:16 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36466 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXL3SWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:22:15 -0500
Date: Sun, 30 Dec 2007 12:22:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-reply-to: <fa.8g+KfLLge6wS5cEnKhZJmdkIVAI@ifi.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <4777E1CC.3080208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PuxU73ceCfHAUeWLO4W21Zbrm7A@ifi.uio.no>
 <fa.ipKZdmvkNYmQ40C0cO+2u3eYohw@ifi.uio.no>
 <fa.ppsa4qOLo1V8UlDNTucnaqIJmKA@ifi.uio.no>
 <fa.3IG7z0AfHuLo9eQjn7Gkl/+/lnA@ifi.uio.no>
 <fa.slc2tTnUBrTGO2aTi/C5UGHEEEM@ifi.uio.no>
 <fa.8g+KfLLge6wS5cEnKhZJmdkIVAI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>> i dont get your last point. Firstly, we do an "outb $0x80" not an 
>>> inb.
>> outb not inb sorry yes
>>
>>> Secondly, outb $0x80 has no PCI posting side-effects AFAICS. 
>>> Thirdly,
>> It does. The last mmio write cycle to the bridge gets pushed out 
>> before the 0x80 cycle goes to the PCI bridge, times out and goes to 
>> the LPC bus.
> 
> ok. Is it more of a "gets flushed due to timing out", or a 
> specified-for-sure POST flushing property of all out 0x80 cycles going 
> to the PCI bridge? I thought PCI posting policy is up to the CPU, it can 
> delay PCI space writes arbitrarily (within reasonable timeouts) as long 
> as no read is done from the _same_ IO space address. Note that the port 
> 0x80 cycle is neither a read, nor for the same address.

There's no guarantee in the spec that any IO access will flush pending 
MMIO writes. However, I suspect in the majority of implementations 
(perhaps all), it indeed does.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

