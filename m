Return-Path: <linux-kernel-owner+w=401wt.eu-S1946354AbXBILkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946354AbXBILkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946356AbXBILkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:40:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946354AbXBILkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:40:07 -0500
Date: Fri, 9 Feb 2007 03:39:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070209033936.41be141b.akpm@linux-foundation.org>
In-Reply-To: <1171020273.8675.150.camel@laptopd505.fenrus.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
	<20070209105737.GF5785@slug>
	<1171020273.8675.150.camel@laptopd505.fenrus.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 12:24:33 +0100 Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 2007-02-09 at 10:57 +0000, Frederik Deweerdt wrote:
> > +static const int __deprecated SA_INTERRUPT = IRQF_DISABLED;
> > +static const int __deprecated SA_SAMPLE_RANDOM = IRQF_SAMPLE_RANDOM;
> > +static const int __deprecated SA_SHIRQ = IRQF_SHARED;
> > +static const int __deprecated SA_PROBEIRQ = IRQF_PROBE_SHARED;
> > +static const int __deprecated SA_PERCPU = IRQF_PERCPU;
> > +
> > +static const int __deprecated SA_TRIGGER_LOW = IRQF_TRIGGER_LOW;
> > +static const int __deprecated SA_TRIGGER_HIGH = IRQF_TRIGGER_HIGH;
> > +static const int __deprecated SA_TRIGGER_FALLING = IRQF_TRIGGER_FALLING;
> > +static const int __deprecated SA_TRIGGER_RISING = IRQF_TRIGGER_RISING;
> > +static const int __deprecated SA_TRIGGER_MASK = IRQF_TRIGGER_MASK;
> 
> this will include these in every .o file for which the .c file includes
> the header. NOT GOOD(tm)

As long as nobody takes the address of them (which wouldn't compile today
anyway) then the compiler should be able to not allocate store for these. 
That they're const might help too.

> why not just bite the bullet?
> removing version.h also broke the same all external modules, and they
> got fixed in days.. no big deal. kernel api change all the time, this
> one has been around in "double mode" quite some time...

Pretty much every driver in the world will want these symbols.  I expect
we'll help some people by doing this, and the cost to us is very small.  

Plus we're getting a bad reputation out there for breaking stuff and
screwing people around, which isn't good.

