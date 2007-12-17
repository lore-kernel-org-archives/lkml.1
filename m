Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbXLQEKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbXLQEKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 23:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXLQEKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 23:10:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbXLQEKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 23:10:33 -0500
Message-ID: <4765F679.9000707@zytor.com>
Date: Sun, 16 Dec 2007 20:09:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com>
In-Reply-To: <4765DCB0.8030901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 17-12-07 03:05, H. Peter Anvin wrote:
> 
>> Incidentally, I had the thought earlier today that port 0xf0 might be 
>> a suitable delay port.  It is used only by the 387-emulating-a-287 
>> hack for IRQ 13, which Linux doesn't use on 486+.
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> rene@7ixe4:~/src/port80$ su -c ./portf0
> cycles: out 2400, in 2400
> 
> (Duron 1300)
> 
> I suppose you mean using it instead of port 0x80 always and not just as 
> an alternate port? For the latter 0xed is alright I guess...
> 

FWIW, the criterion used in the kernel for when to use IRQ 13 is:

         /*
          * External FPU? Set up irq13 if so, for
          * original braindamaged IBM FERR coupling.
          */
         if (boot_cpu_data.hard_math && !cpu_has_fpu)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                 setup_irq(FPU_IRQ, &fpu_irq);

In that case we can't actually use port 0xF0 (it is, however, safe to 
use it during setup, specifically before we can take our first FPU 
exception.)

	-hpa
