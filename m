Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbZFIHxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbZFIHxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZFIHxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:53:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbZFIHxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:53:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
In-Reply-To: Petr Tesarik's message of  Tuesday, 9 June 2009 09:26:58 +0200 <1244532418.5199.24.camel@nathan.suse.cz>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	<1244215559.1604.12.camel@nathan.suse.cz>
	<20090605200701.GB23195@uranus.ravnborg.org>
	<1244532418.5199.24.camel@nathan.suse.cz>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
Date: Tue,  9 Jun 2009 00:52:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am wondering why we need -P -C here - but we do not need it for lds.S files?
> > Seems like something we could let go.

AFAIK these only affect readability of the lds.s output files.
The difference should be entirely cosmetic.

> > > >  	.altinstructions	: { *(.altinstructions) }
> > > > @@ -43,9 +42,49 @@ SECTIONS
> > > >  	 */
> > > >  	. = ALIGN(0x100);
> > 
> > What is 0x100?
> 
> Um. No idea. Roland, you added this line in commit
> f6b46ebf904f69a73907a5e6b1ed2228e3f03d9e. Can you shed some light on
> this magic constant?

You mean this one:

	/*
	 * Align the actual code well away from the non-instruction data.
	 * This is the best thing for the I-cache.
	 */
	. = ALIGN(0x100);

Reading the comment might make it obvious that it's intended for optimal
code alignment.  I suspect someone at the time told me 256 is as big as an
I-cache line was ever likely to get.  You could use L1_CACHE_BYTES instead
I suppose.

> What would you expect? The linker script language is quite limited in
> its capabilities... Best I could do is split the ".broken" section into
> several sections and move the descriptions from the individual comments
> above here. If this muckle of empty ".broken.*" sections gets correctly
> discarded and triggers no bug in binutils, I can probably do it.

Adding more sections and section names unnecessarily bloats the size of the
vDSO image.  Keep the set of output sections to the necessary minimum.


Thanks,
Roland
