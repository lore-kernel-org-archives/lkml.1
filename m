Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbZE1NMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbZE1NMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZE1NMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:12:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:60064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806AbZE1NMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:12:36 -0400
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
From: Petr Tesarik <ptesarik@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.LFD.2.00.0905280830150.31093@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
	 <1243513274.3170.1.camel@nathan.suse.cz>
	 <alpine.LFD.2.00.0905280830150.31093@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 28 May 2009 15:12:37 +0200
Message-Id: <1243516357.8310.4.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day píše v Čt 28. 05. 2009 v 08:32 -0400:
> On Thu, 28 May 2009, Petr Tesarik wrote:
> 
> > Robert P. J. Day píše v Čt 23. 04. 2009 v 13:43 -0400:
> > > A boolean single_bit_set() routine would simplify the numerous
> > > constructs of the form (((n & (n - 1)) == 0)) when testing for
> > > single-bitness.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > >
> > > ---
> > >
> > > This is similar to the current is_power_of_2() routine defined in
> > > include/linux/log2.h, which is mathematically identical but,
> > > semantically, should be defined independently just so the code is more
> > > readable.
> > >
> > > I'm open to an alternative function name.
> >
> > ispow2() ?
> >
> > Because what it really does is to check that a value is a power of two,
> > doesn'it.
> 
>   by the way, a search for places in the code that are candidates for
> this kind of rewriting can be seen at one of my wiki kernel cleanup
> pages:
> 
>   http://www.crashcourse.ca/wiki/index.php/The_style_script

Ah, yes, sorry, I missed the top of your email.

Ok, then my only concern is that the hweight* functions return the exact
weight, which might be much less efficient if all we need is to know
whether it's 1.

Theoretically, gcc should be able to optimize things out, but I'm not
all that optimistic about how well it does it.

Petr Tesarik


