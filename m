Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbYAaByN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbYAaByN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYAaBx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:53:58 -0500
Received: from ms01.sssup.it ([193.205.80.99]:53696 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753595AbYAaBx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:53:57 -0500
Message-ID: <47A12A2E.5040309@gandalf.sssup.it>
Date: Thu, 31 Jan 2008 02:53:50 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it>	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	<47A051A7.7030004@gandalf.sssup.it>	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	<47A09723.7020000@gandalf.sssup.it> <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Haavard Skinnemoen wrote:
> On Wed, 30 Jan 2008 16:26:27 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
>
>   
>>> I have no idea. Could you post some more specifics about what you
>>> modified, for example a diff?
>>>
>>>     
>>>       
>> ...
>> /* The interrupt handler does not take the lock */
>> spin_lock_irqsave(&port->lock, flags);
>> atmel_tx_chars(port);
>> spin_unlock_irqrestore(&port->lock, flags);
>>     
>
> Sorry, this isn't going to work.
>
> Please post a diff with the changes you did to the driver, and whatever
> output you got when it crashed.
>
> It's really difficult to help you when I don't know (a) what code
> you're actually running, or (b) anything about the crash.
>
>   
Ok, but the problem is that I have some added code for using the uart with
smart card in iso mode, (is never called) and the patch is not so clean.
Now I return to the original patch without the spin_lock_irqsave and with
the fix of buffer allocation,and I don't see the crash anymore.
In full preemptive all works with threading hardirqs and sofirqs. I will
do other testing before posting again.
>> The atmel_tx_chars using the serial device registers like the interrupt 
>> routine
>> and so I think that it is possible to have interference during send 
>> operation.
>>     
>
> No, it's only called from the tasklet, and the interrupt handler doesn't
> touch the TX data register. There shouldn't be any need to disable
> interrupts around the call to atmel_tx_chars(). In fact, this may very
> well be the cause of the overruns you're seeing.
>
> Haavard
>
>   
The overrun still remain. An lrz receive session is impossible using
full preemption. I will try the dma patch too and test in iso mode for 
smart card.

Thanks
