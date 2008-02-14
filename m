Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbYBNHbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbYBNHbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbYBNHbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:31:07 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:54675 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbYBNHbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:31:06 -0500
Message-ID: <47B3EE27.6000902@gandalf.sssup.it>
Date: Thu, 14 Feb 2008 08:30:47 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	 <47A12A2E.5040309@gandalf.sssup.it>	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>	 <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>	 <47A9A5B5.3060800@gandalf.sssup.it>	 <3efb10970802061141x5fdecefao8f617265aed7cb6f@mail.gmail.com>	 <47B2CF76.6050704@gandalf.sssup.it> <3efb10970802131213y717d0c12t151ab9c61f4e9955@mail.gmail.com>
In-Reply-To: <3efb10970802131213y717d0c12t151ab9c61f4e9955@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Remy Bohmer wrote:
> Hello All,
>
>   
>> All works now for me with preempt-rt. The problem is using hrtimer.
>> I think that hrtimer are executed with interrupts disabled so, if
>> this happen when I must receive a char, i have an overrun.
>>     
>
> No, they share the same interrupt line...
>   
I think that the hrtimer use and other interrupt line. The 
AT91SAM9260_ID_TC2.
> So, while the timer interrupt handler is running, the serial handler
> has to wait until the timer interrupt handler has finished.
> Notice that the HRT interrupt handler is quite heavy and takes a long
> time to complete.
>   
The problem is the heavy of HRT interrupt handler of course.
> And, as I already mentioned, related to the 1 byte FIFO and a
> interrupt latency of about 85us (without HRT), it is logical that you
> can get an overrun at the higher serial speeds... (>=115200bps)
>
>   
I don't have the same problem without the hrtimer, I suppose the the 
timer latency
is not so heavy.
>> The only solution was the dma support to serial device.
>>     
>
> Or, use flow control?
>
>
>   
Yes :)

Michael

