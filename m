Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYBZKgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYBZKgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYBZKgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:36:23 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:31423 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751007AbYBZKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:36:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OGxozp4DTRe0rnoUDMrCUZcum6OshfgL0Taf4BI3SIHobCz6v/xNy4IrLy7zvhJZUTr7zOA8CCNMnusZ6qAKiKwJKRrQvXpfKJDXqseZZiIIrKzKxNceFmUDQN95dg+0QK9nSwlsS+Ho3UMtHkJXyw3rYxo+tbcMeG22pDZLWvo=  ;
X-YMail-OSG: qPp8WpAVM1n7N0UenZJTIjcItXH.DlTEpGqVO_jyPv2l7bnyjE4Eeag3DxFHZbzZTCgP9j7aHw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
Date: Tue, 26 Feb 2008 02:36:16 -0800
User-Agent: KMail/1.9.6
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
References: <20080225223338.9602E25E979@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <1204019626.6242.225.camel@lappy>
In-Reply-To: <1204019626.6242.225.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260236.17188.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Peter Zijlstra wrote:
> 
> On Mon, 2008-02-25 at 14:33 -0800, David Brownell wrote:
> 
> > > +#ifdef CONFIG_LOCKDEP
> > > +
> > > +/* tell lockdep that this IRQ's locks and its parent's locks are in
> > > + * different categories, so that it won't detect false recursion.
> > > + */
> > > +static struct lock_class_key gpio_lock_class;
> > > +
> > > +static inline void mark_gpio_locking(unsigned gpio_irq)
> > > +{
> > > +	lockdep_set_class(&irq_desc[gpio_irq].lock, &gpio_lock_class);
> > > +}
> > > +
> > > +#else
> > > +
> > > +	...
> 
> Glad to hear this works out for you.

Yeah, glad to have a localized fix rather than mucking with genirq.


> Just one note, you don't need the #ifdef mess here. struct
> lock_class_key is 0 bytes on !LOCKDEP and lockdep_set_class*() is
> defined away as well.

Hmm, then kernel/irq/handle.c shouldn't need #ifdefs either ... ;)

