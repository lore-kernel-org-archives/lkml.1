Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYGALfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYGALfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYGALe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:34:58 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:16961 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751534AbYGALe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:34:57 -0400
Date: Tue, 1 Jul 2008 15:34:53 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RT] MPIC edge sensitive issues with hardirq preemption
Message-ID: <20080701113453.GA27260@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru> <1214781974.20711.7.camel@pasglop> <20080630190132.GA6492@polina.dev.rtsoft.ru> <486A09CF.1040405@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <486A09CF.1040405@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:41:19PM +0400, Sergei Shtylyov wrote:
> Hello.
>
> Anton Vorontsov wrote:
>
>> But how this could be a bug in the PIC code? IMO this is a bug in the
>> kernel/irq code, since it assumes that fasteoi PIC will retrigger masked
>> edge sources... This isn't true for at least MPIC. To make this work for
>> all fasteoi PICs, we should mask edge sensitive interrupts very very
>> carefully.
>>   
>
>   I guess it assumed this based on 8259's behavior (not sure about I/O  
> APIC).
>   Hm, but the 8259 code never used "fasteoi" path for some obscure  
> reason...
>
>> jammed with the idea that MPIC irq type 0 is low level sensitive, but the
>> true thing is that it is rising edge sensitive. (Ah, I know where I got
>> confused, type 0 is active-low for ISA PICs).
>>   
>
>    You mean in the device tree?

Yes, simply changing device tree.

>> So in all my previous emails I was wrong when I was saying "mpic is
>> programmed to low level sensitive". It was programmed for rising edge
>> sensitive. An all my further reasonings were flawed because of this.
>>   
>
>   Gah.  I'm surprised how it could work at all then...
>
>> Re-programming MPIC to high level sensitive also makes IDE work. But
>> this doesn't mean that IRQ code is correct.
>>   
>
>   I wonder why. :-O
>   Your ULi IDE is in native mode, so it should be generating a PCI  
> interrupt -- which is *low* level sensitive.

Exactly. This is another reason why I was so confused.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
