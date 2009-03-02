Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZCBXsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZCBXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZCBXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:48:24 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:47020 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752852AbZCBXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:48:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0xW+3ldSHOn00bI/05u4L+7IC6RpNBQQpkmTcZmjr2zhm5uMzOa6kqI6kk8d4lVql2u4XgeA8wyrbER2Z/dNFIBaMnpBNLv16d6e7CHlQmOx6t4B2Zdi9FAYQMaS0+mvg/w1FDN5UBkQkJK/L9E5K9VMmL/I5llPlVBx+Qp4zMA=  ;
X-YMail-OSG: qcIfuDQVM1n1xlagHwdDLjecwwGijOPgBuw7Oja_uiIJFoU6293hvQ8NIOqjybXd9p7_S28L2Dn8LdB0xTxUsRi9vOV7RprMWKGJGUyAURRGPbr.o3QxmnBO_AHMno6yBi7hjUEmSzMGXkYUS_VhCHwDHm8mHj8gAR8daft67ZyORhGh9SvaX6QgyfSN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 15:48:18 -0800
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021520.30826.david-b@pacbell.net> <20090302232650.GA14515@elte.hu>
In-Reply-To: <20090302232650.GA14515@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903021548.19504.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Ingo Molnar wrote:
> 
> > > > What's unfortunate is that you prefer not to fix that
> > > > IRQF_DISABLED bug in lockdep, which you co-"maintain".
> > > > When running with lockdep, that bug (a) introduces bugs
> > > > in some drivers and (b) hides bugs in others.  You've
> > > > rejected even a minimal warning fix, to help minimize
> > > > the amount of time developers waste on (a) and (b).
> > > 
> > > I've come to the conclusion that the only technically sound solution is
> > > to do as I proposed today, utterly eliminate !IRQF_DISABLED handlers.
> > 
> > As you announced today.  If you truly believe that, then
> > you should at least submit a warning patch for 2.6.29-rc
> > ("driver X isn't setting IRQF_DISABLED, reimplement!")
> 
> i have changed the BUG_ON() to a WARN_ONCE() message so the 
> warning is in place now.

The patch Peter sent doesn't relate in the least to removing
the IRQF_DISABLED flag though.  Patches addressing that
would be in setup_irq() code paths not IRQ dispatch.


> > with a Documentation/feature-removal-schedule.txt plan for 
> > removing that mechanism. [...]
> 
> you are misunderstanding the workings and purpose of 
> feature-removal-schedule.txt. It is mainly used for 
> functionality that is user-visible.

If by "user" you include "kernel developers", yes;
otherwise, I'd dispute "mainly".  The first several
entries right now relate to kernel interfaces, as
do quite a lot of the others.


> It is sometimes used for  
> functionality that a subsystem has exported to a lot of drivers 
> consciously and which is being removed.

The IRQ framework has very consciously exported IRQF_DISABLED.
That functionality has been around for a very long time; I'm
thinking at least ten years now.

So removing IRQF_DISABLED -- if it's even agreed to be
a good idea, which seems to be a minority opinion so far
on this thread -- is very much the sort of thing one would
expect to appear in that schedule.

