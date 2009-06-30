Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZF3GNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZF3GNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZF3GNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:13:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:47014 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZF3GNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:13:00 -0400
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
From: Petr Tesarik <ptesarik@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906291448510.3864@localhost>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
	 <49F0C817.8050407@caviumnetworks.com>
	 <20090423165723.16c9f566.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>
	 <20090424104651.7c751735.akpm@linux-foundation.org>
	 <1246299311.7698.19.camel@nathan.suse.cz>
	 <alpine.LFD.2.00.0906291448510.3864@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 30 Jun 2009 08:12:59 +0200
Message-Id: <1246342379.31661.5.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day píše v Po 29. 06. 2009 v 14:50 -0400:
> On Mon, 29 Jun 2009, Petr Tesarik wrote:
> 
> > Andrew Morton píše v Pá 24. 04. 2009 v 10:46 -0700:
> > > On Fri, 24 Apr 2009 06:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > >
> > > >   so it would be a simple matter to define the bit set boolean in
> > > > terms of hweight_long(), yes?  so what about, in bitops.h:
> > > >
> > > >   static inline bool
> > > >   exactly_one_bit_set(unsigned long w)
> > > >   {
> > > > 	return hweight_long(w) == 1;
> > > >   }
> > > >
> > > >   static inline bool
> > > >   more_than_one_bit_set(unsigned long w)
> > > >   {
> > > > 	return hweight_long(w) > 1;
> > > >   }
> > > >
> >
> > Andrew, you must be kidding! Are you seriously suggesting to replace
> > a simple and instruction with a call to an extern library function
> > with 17 instructions (not including the call and ret)?
> >
> > I'd better check the use of hweight in the kernel to eradicate as
> > many calls to it as possible...
> 
>   since i originally muttered about this, the rationale behind it was
> not for performance (obviously), but for semantic clarification, so
> that when you saw the expression "n & (n-1)", it was more obvious
> which test you were doing semantically:
> 
> 1) is n a power of 2?
> 2) does n represent a single set bit?
> 
> nothing ever came of that, but that was the thinking behind it.

Yes, I can remember and I would still appreciate it. It's always better
to show _what_ the code does rather than _how_ it does it.

IIRC Andrew rejected your patch on the grounds that it is possible to
replace the expression "n & (n-1)" with "hweight(n) == 1" if one wants
to show that it really tests for a single bit set. But I don't like his
proposal quite as much as yours, because of the big overhead.

In short, if you re-post your patch, I'll gladly join you in the battle
of getting it in. ;-)

Petr Tesarik


