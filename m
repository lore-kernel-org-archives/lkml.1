Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZBXNcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZBXNcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZBXNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:32:11 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:57602 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZBXNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oOz2zAm2xNA3/N5iIYJ0BmZNaxEZdEXN4NerKmSEfbg82RiYNpXlGtf5waZGClkjWT
         zC2qjtg7JRAEpk76oEh+5VDUw+ttovO/+qDHpBoaswIeORYe1P+GywB7oXyUpIckZAIJ
         3oNrtMt6vpb8RcDVxQl+XNqaAXf2z3+h/Zhdo=
Message-ID: <49A3F6D3.4030703@gmail.com>
Date: Tue, 24 Feb 2009 14:32:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: quirk_usb_disable_ehci takes 2x 1.5s on boot
References: <49620DF7.9040006@gmail.com> <4962A792.9070706@shaw.ca>
In-Reply-To: <4962A792.9070706@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2009 01:36, Robert Hancock wrote:
> Jiri Slaby wrote:
>> I don't know since which moment (maybe I changed something in bios,
>> but usb
>> legacy kbd was ever enabled), but quirk_usb_disable_ehci takes for
>> both of my
>> ehci controllers 1.5 s.
>>
>> More precisely, the time is spent in
>> pci_write_config_byte(pdev, offset + 3, 1);
>> by
>> outb((u8)value, 0xCFC + (reg & 3));
>> from pci_conf1_write deep in the callstack.
>>
>> Is there any workaround known or something. Turning legacy usb off is
>> not an
>> option, I want to control grub.
>
> Most likely the PCI config space write is causing some SMM trap and the
> BIOS is taking forever to do whatever it's doing. It doesn't report that
> the handoff failed, though?

Some time ago there was something like that:
http://kerneltrap.org/mailarchive/linux-kernel/2007/9/24/273262
I haven't seen it since that time.

> I'd look for a BIOS update..

I can't find any, bad luck. It's some kind of testing machine sample...

Nevermind, it obviously doesn't occur during kexeced kernel bootup, I 
can live with that :).
