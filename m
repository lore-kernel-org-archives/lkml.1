Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYJUIBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYJUIBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYJUIBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:01:23 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:36967 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751772AbYJUIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:01:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VNDZcsKCJ2C2Fu1vSpKHpxITgOJ0MmtQLbYA6unpBreiOor4C6oY7ljzPou2K7hyasKqMS3+V4mE6Pj7regFDwpPeU2w8WDtZ/T9R2cWK2GB1xjajivJO6j/an52UjQE7on6JIp4AY2JCL2X9t+B9WS8a4KPC2uddDN8KiN6GoA=  ;
X-YMail-OSG: tadPiP0VM1l5aMuin0TZBS2Si8cBH6MmfGRwSjMLrcBtGXQXm57gZQSwwnuEHuIKpB1zfemEL__2TjG6_mr31KQYKIlny0Cs9IdxNKsdoUbW3X3WKiA5kq6NfA8a6bhoqg9ydtbAuLiCO.Pr7ApmXYaG7n9oUK6WzemT8hQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org
Subject: Re: Bug in "genirq: record trigger type"
Date: Tue, 21 Oct 2008 01:01:19 -0700
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linuxppc-dev list" <linuxppc-dev@ozlabs.org>
References: <200810202205.m9KM5une024759@hera.kernel.org> <1224570730.7654.242.camel@pasglop>
In-Reply-To: <1224570730.7654.242.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810210101.19741.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008, Benjamin Herrenschmidt wrote:
> This one is obviously broken and breaks booting on a whole bunch of
> machines (including powermac's and thus my G5, it's never good when my
> own machine breaks !).
> 
> Nice to see 3 SOB's and one Ack and nobody caught the obvious bug :-)

As you saw, that one's fixed.  Chris' patch unfortunately didn't
get integrated right away.


I'm a bit more curious about another potential issue though ... as
described in the patch comment:

     - Make set_irq_type() usage match request_irq() usage:
        * IRQ_TYPE_NONE should be a NOP; succeed, so irq_chip methods
          won't have to handle that case any more (many do it wrong).

It might be a bit more accurate to say irq_chip.set_type() methods
are *inconsistent* in handling IRQ_TYPE_NONE.  Previously the
set_irq_type() method would pass that down to irq_chip code. 

I had observed two behaviors, but I thought I observed a third one
in some of the PowerPC code:

 (1) ignore it ... matching request_irq() usage
 (2) return an error ... nasty
 (3) assign some irq_chip-specific trigger mode

That third behavior might cause a bit of trouble, but I think
it was only used during platform init.  Someone more attuned
to PowerPC might want to check ...

- Dave

