Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZCKWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZCKWDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZCKWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:01:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:46126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZCKWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:01:07 -0400
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Timur Tabi <timur@freescale.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
In-Reply-To: <49B80081.5060703@freescale.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 08:58:42 +1100
Message-Id: <1236808722.7086.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 13:18 -0500, Timur Tabi wrote:
> Alan Cox wrote:
> >> Are you talking about the udelay() inside the loop?  If so, I agree
> >> that this is bad and have removed it in the PowerPC-specific version:
> > 
> > The behaviour you want there is system specific - 10uS is a minimum
> > politeness value for x86 PCI bus for example.
> 
> So we need to allow for delays between successive rights?  We can
> provide that with a third parameter to the macro.

I prefer Alan's method of having the macro be followed by { and } so we
can add things in there. The delay between access will often be somewhat
platform or device specific, and some drivers might be able to do useful
things while spinning.

The other big advantage of that approach is that drivers that aren't in
an atomic section can use msleep() and allow the kernel to schedule on
that processor.

> Is there an architecture-independent method for reading a timebase
> register that's not jiffies?

Not really since there isn't an architecture independent "timebase
register" anyway. But Jiffies for the timeout value doesn't sound
necessarily -that- bad.

Cheers,
Ben.


