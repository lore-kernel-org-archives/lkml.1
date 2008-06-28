Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbYF1LwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbYF1LwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYF1LwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:52:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:39033 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYF1LwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:52:11 -0400
Message-ID: <486625E2.2020808@ru.mvista.com>
Date: Sat, 28 Jun 2008 15:52:02 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with	preemptable
 hardirqs
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru> <486612CC.3060505@ru.mvista.com> <20080628113126.GA438@polina.dev.rtsoft.ru>
In-Reply-To: <20080628113126.GA438@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:
>>> But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
>>> behaves in a strange way: it asserts interrupts as edge sensitive. And
>>> because preemptable IRQ handler disables PIC's interrupt, PIC will likely
>>> miss it.
>>>   
>>>       
>>   Unmasking an IRQ should re-enable an edge detector in a PIC (or that  
>> detector should even be independent from mask).
>>     
> Should? Hm.. well, I can easily check it. Will just program the MPIC IRQ
> to edge sensitive, and see if it fixes the problem (not sure if I already
> tried this, I think I did try).
>   

   That will not help if edge detector is not active for masked out IRQs 
(that's how i8259 behaves, IIRC) *and* you're getting the short IRQ 
"pulses" but should help if IRQ is generated normally -- though in this 
case the level trigger mode (with the same polarity) should work as well...

MBR, Sergei


