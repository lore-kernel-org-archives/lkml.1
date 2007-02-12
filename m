Return-Path: <linux-kernel-owner+w=401wt.eu-S932945AbXBLDRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbXBLDRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbXBLDRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:17:32 -0500
Received: from ozlabs.org ([203.10.76.45]:50520 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbXBLDRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:17:32 -0500
Date: Mon, 12 Feb 2007 14:17:28 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Add a set_irq_handler_locked() function
Message-ID: <20070212031728.GA30401@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070207023353.GC23870@localhost.localdomain> <1170940949.3646.1.camel@chaos> <20070209034842.GF3489@localhost.localdomain> <20070209073640.GA29988@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209073640.GA29988@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 07:36:40AM +0000, Russell King wrote:
> On Fri, Feb 09, 2007 at 02:48:42PM +1100, David Gibson wrote:
> > At present set_irq_handler() and all the existing variants take the
> > desc->lock for the irq in question before adjusting the irq's flow
> > handler.  This can cause problems for irq chips for which a given
> > interrupt can be either level or edge depending on what's attached.
> 
> Are you sure you need to change the flow handler depending on how
> you program the device?
> 
> Since the outset of this design, I've had what are essentially edge
> based interrupt sources using the "level" handlers because they haven't
> had a "broken" edge implementation.  By that, I mean that the masking
> is done in such a way that you miss edges when the source is masked.
> 
> If you do not miss edges while the source is masked, there's no point
> in having the complexity of the "edge" based handler in the path - it
> buys you nothing.  Just use the "level" handler instead.

I see... how terribly obvious.

As far as I know, the 4xx UIC does things correctly, though I don't
have handy any devices with edge interrupts to test it with.

It would still be nice to have this change, so we can use the
lazy-masking from handle_edge_irq(), but I guess I can do without it
for now.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
