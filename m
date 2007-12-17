Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXLQNbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXLQNbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXLQNb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:31:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55201 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbXLQNb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:31:27 -0500
Date: Mon, 17 Dec 2007 14:31:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217133120.GA11321@elf.ucw.cz>
References: <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47667812.8050708@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-17 14:22:26, Rene Herman wrote:
> On 17-12-07 14:09, Ingo Molnar wrote:
>
>>>> -#ifndef CONFIG_UDELAY_IO_DELAY
>>>> -static int __init dmi_alternate_io_delay_port(const struct 
>>>> dmi_system_id *id)
>>>> +static int __init dmi_io_delay_0xed_port(const struct dmi_system_id 
>>>> *id)
>>>>  {
>>>> -	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
>>>> -	io_delay = alternate_io_delay;
>>>> +	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
>>>> +	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
>>>> +
>>>>  	return 0;
>>>>  }
>>> This isn't correct. DMI shouldn't override the CONFIG choice or someone 
>>> with matching DMI will have a defective CONFIG option. That's why I put 
>>> all of it inside #ifndef.
>> no, the DMI quirk is just that: a quirk that makes boxes work. The DMI 
>> quirk takes precedence over just about any .config default, except an 
>> explicit boot-commandline override.
>
> No, most definitely not. Having the user select udelay or none through the 
> kernel config and then the kernel deciding "ah, you know what, I'll know 
> better and use port access anyway" is _utterly_ broken behaviour. Software 
> needs to listen to its master.

That's what command line is for. Ingo is right here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
