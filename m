Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbXLQNYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbXLQNYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXLQNYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:24:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:16136 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbXLQNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=GDtQaLUUrdt7xpCCS/FdL6m2dyFEA4kbyp2vz896A7fjNlp3Zg2wV3R8cVQx/t+f24Yowt9CYL8Zk0QVunqACQsAPxpKUYF0W+GyC90Lw+V/HCLEJyO3TqWQVJn1lW67IqxAu6ZrEl/AzBp5sjYjS1olTU3E7Ya67RWKKX7zGzE=
Message-ID: <47667812.8050708@gmail.com>
Date: Mon, 17 Dec 2007 14:22:26 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu>
In-Reply-To: <20071217130933.GB27992@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 14:09, Ingo Molnar wrote:

>>> -#ifndef CONFIG_UDELAY_IO_DELAY
>>> -static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
>>> +static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
>>>  {
>>> -	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
>>> -	io_delay = alternate_io_delay;
>>> +	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
>>> +	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
>>> +
>>>  	return 0;
>>>  }
>> This isn't correct. DMI shouldn't override the CONFIG choice or 
>> someone with matching DMI will have a defective CONFIG option. That's 
>> why I put all of it inside #ifndef.
> 
> no, the DMI quirk is just that: a quirk that makes boxes work. The DMI 
> quirk takes precedence over just about any .config default, except an 
> explicit boot-commandline override.

No, most definitely not. Having the user select udelay or none through the 
kernel config and then the kernel deciding "ah, you know what, I'll know 
better and use port access anyway" is _utterly_ broken behaviour. Software 
needs to listen to its master.

Rene.
