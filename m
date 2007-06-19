Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXFSQIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXFSQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXFSQIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:08:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:38321 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753723AbXFSQIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:08:42 -0400
Message-ID: <4677FFF1.2010308@ru.mvista.com>
Date: Tue, 19 Jun 2007 20:10:25 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Stuart_Hayes@Dell.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com> <DFEF91B22ED07447AB6AA4B237F913F9B18A05@ausx3mpc125.aus.amer.dell.com> <4677E30B.4020101@ru.mvista.com> <20070619150502.GO5836@austin.ibm.com>
In-Reply-To: <20070619150502.GO5836@austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Linas Vepstas wrote:

>>Stuart_Hayes@Dell.com wrote:

>>>I think reading the IDE status register clears the interrupt in the IDE
>>>device, which might be causing the drive to think it's OK to generate
>>>another interrupt.

>>   This is not how IDE drives are supposed to act -- they won't proceed any 
>>further until "interrupt pending" condition is cleared, so these aren't 
>>supposed to be "stacked". This behavior however is not strictly specified 
>>by ATA standards IIRC, but I can't readily imagine such situaltion anyway 
>>unless tagged command queueing  (which is not supported by IDE core) and/or 
>>ATAPI command overlapping is in action...

> The problem only manifests during high io load; perhaps a missing mutex
> somewhere is blasting one thing too many out to the hard drive?

    Hm... not sure about this.

>>>This could either cause it to get stuck trying to
>>>service an interrupt that is never getting cleared as you suggested, or
>>>possibly when the next IRQ comes in the IDE IRQ handler gets stuck
>>>waiting for a spinlock that the code you're looking at already owns...?

>>   I could also imagine the HPT366 chip going mad and stalling the reads if 
>>the taskfile regs forever because of the incomplete DMA or even the drive 
>>going mad and not replying to I/O cycles with proper -IORDY handshake (i.e. 
>>holding it low all the time)...

> In my case, ctrl-alt-sysrq doesn't work, which makes it hard to debug.

> I'm thinking that trying to debug libata is a better idea, rather than
> investing time in ide, right?  Although at the moment, libata works even 
> less; see other email.

    Which makes me think this really is some *hardware* issue.

> --linas

MBR, Sergei
