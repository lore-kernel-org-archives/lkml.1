Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924Ab0AYXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0AYXcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342Ab0AYXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:32:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41996 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0AYXcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:32:06 -0500
Message-ID: <4B5E29E0.4030605@zytor.com>
Date: Mon, 25 Jan 2010 15:31:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, Robert Hancock <hancockrwd@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <4B57A2D4.9030204@gmail.com> <20100121185544.GB11996@core.coreip.homeip.net> <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com> <20100121221701.GA15293@core.coreip.homeip.net> <20100125163433.GB31957@suse.cz> <4B5E0DFA.8080705@zytor.com> <20100125221520.GA30307@core.coreip.homeip.net> <4B5E18C0.7060402@zytor.com> <20100125223004.GB30307@core.coreip.homeip.net> <4B5E23BB.1090806@zytor.com> <20100125232801.GD30307@core.coreip.homeip.net>
In-Reply-To: <20100125232801.GD30307@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 03:28 PM, Dmitry Torokhov wrote:
> 
> /*
>  * i8042_flush() flushes all data that may be in the keyboard and mouse
>  * buffers
>  * of the i8042 down the toilet.
>  */
> 
> static int i8042_flush(void)
> {
>         unsigned long flags;
>         unsigned char data, str;
>         int i = 0;
> 
>         spin_lock_irqsave(&i8042_lock, flags);
> 
>         while (((str = i8042_read_status()) & I8042_STR_OBF) && (i < I8042_BUFFER_SIZE)) {
>                 udelay(50);
>                 data = i8042_read_data();
>                 i++;
>                 dbg("%02x <- i8042 (flush, %s)", data,
>                         str & I8042_STR_AUXDATA ? "aux" : "kbd");
>         }
> 
>         spin_unlock_irqrestore(&i8042_lock, flags);
> 
>         return i;
> }
> 

Given that I would say it's pretty safe to say the A20 code doesn't get
executed on these boxes, so I don't think there is anything I can add
here, unfortunately.

	-hpa
