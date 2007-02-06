Return-Path: <linux-kernel-owner+w=401wt.eu-S965320AbXBFS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320AbXBFS6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXBFS6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:58:18 -0500
Received: from gate.criticalsoftware.com ([212.13.37.242]:7888 "EHLO
	gate.criticalsoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965246AbXBFS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:58:16 -0500
From: Jorge Almeida <j-almeida@criticalsoftware.com>
Reply-To: j-almeida@criticalsoftware.com
Organization: Critical Software
To: "Remy Bohmer" <l.pinguin@gmail.com>
Subject: Re: IRQ Sharing
Date: Tue, 6 Feb 2007 18:54:15 +0000
User-Agent: KMail/1.9.5
References: <200702061801.58465.j-almeida@criticalsoftware.com> <3efb10970702061043m43f5b3eelfa24fbb95721acb4@mail.gmail.com>
In-Reply-To: <3efb10970702061043m43f5b3eelfa24fbb95721acb4@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061854.15320.j-almeida@criticalsoftware.com>
X-Copyrighted-Material: Please visit http://www.criticalsoftware.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tuesday, 6 de February de 2007 18:43, o Remy Bohmer escreveu:
> Hello Jorge,
Hello Remy,
> 
> It is not uncommon that interrupt lines are hardwired to each other on
> a standard PC-board.
> Therefor it is not always feasible to get rid of interrupt sharing.
> Especially on-board USB adapters can easily use up to 5 interrupt
> lines on a standard main-board. Also, sharing of interrupt lines (by
> hardwiring them) between on-board devices and PCI slots is also common
> practice.
> 
> The PCI specification explicitly states that PCI devices can share
> interrupt lines, and that your drivers must be capable of handling
> this.
> 
> Why is sharing a problem for you?
> 
> If you do not have special realtime requirements, it usually should be
> no problem...

Thats the problem.
I have real time requirements.

The physic IRQ line can be shared, the only thing i need is the virtual IRQ to 
be different for each device.
This way my real-time drivers already work great :)

So i need to change the APIC way of distribute virtual IRQs.

Jorge

> 
> 
> Remy
> 
> 
> 2007/2/6, Jorge Almeida <j-almeida@criticalsoftware.com>:
> >
> > Hello to all.
> >
> > I'm running an application that uses several IO boards in a PCI bus.
> >
> > My main problem is the virtual IRQ sharing between several boards.
> > I mean for example:
> >         1 ethernet board IRQ = 169;
> >         1 ADC card IRQ         = 169;
> >
> > I want to get ride of this behaviour, and changing the slot position of 
each
> > board is not enought, to get something like (for example):
> >         1 ethernet board IRQ = 169;
> >         1 ADC card IRQ         = 170;
> >
> > Where in the kernel i can see the algorithms for the APIC system where the
> > virtual IRQs are distributed? Or exist already any patch that permits to
> > solve my problem?
> >
> > I'm using kernel 2.6.16.27, in a single machine with Intel pentium IV
> > processor and chipset ICH4.
> >
> > Thanks for any reply.
> > Greetings.
> >
> > --
> > Jorge Almeida
> > j-almeida@criticalsoftware.com
> > DISCLAIMER: This message may contain confidential information or 
privileged material and is intended only for the individual(s) named. If you 
are not a named addressee and mistakenly received this message you should not 
copy or otherwise disseminate it: please delete this e-mail from your system 
and notify the sender immediately. E-mail transmissions are not guaranteed to 
be secure or without errors as information could be intercepted, corrupted, 
lost, destroyed, arrive late or incomplete or contain viruses. Therefore, the 
sender does not accept liability for any errors or omissions in the contents 
of this message that arise as a result of e-mail transmissions. Please 
request a hard copy version if verification is required. Critical Software, 
SA.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jorge Almeida
j-almeida@criticalsoftware.com
DISCLAIMER: This message may contain confidential information or privileged material and is intended only for the individual(s) named. If you are not a named addressee and mistakenly received this message you should not copy or otherwise disseminate it: please delete this e-mail from your system and notify the sender immediately. E-mail transmissions are not guaranteed to be secure or without errors as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete or contain viruses. Therefore, the sender does not accept liability for any errors or omissions in the contents of this message that arise as a result of e-mail transmissions. Please request a hard copy version if verification is required. Critical Software, SA.
