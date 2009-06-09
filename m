Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZFIH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZFIH5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZFIH5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:57:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:51452 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZFIH5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:57:37 -0400
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	 <1244215559.1604.12.camel@nathan.suse.cz>
	 <20090605200701.GB23195@uranus.ravnborg.org>
	 <1244532418.5199.24.camel@nathan.suse.cz>
	 <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 09 Jun 2009 09:57:37 +0200
Message-Id: <1244534257.5199.31.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath píše v Út 09. 06. 2009 v 00:52 -0700:
> > > I am wondering why we need -P -C here - but we do not need it for lds.S files?
> > > Seems like something we could let go.
> 
> AFAIK these only affect readability of the lds.s output files.
> The difference should be entirely cosmetic.
> 
> > > > >  	.altinstructions	: { *(.altinstructions) }
> > > > > @@ -43,9 +42,49 @@ SECTIONS
> > > > >  	 */
> > > > >  	. = ALIGN(0x100);
> > > 
> > > What is 0x100?
> > 
> > Um. No idea. Roland, you added this line in commit
> > f6b46ebf904f69a73907a5e6b1ed2228e3f03d9e. Can you shed some light on
> > this magic constant?
> 
> You mean this one:
> 
> 	/*
> 	 * Align the actual code well away from the non-instruction data.
> 	 * This is the best thing for the I-cache.
> 	 */
> 	. = ALIGN(0x100);
> 
> Reading the comment might make it obvious that it's intended for optimal
> code alignment.  I suspect someone at the time told me 256 is as big as an
> I-cache line was ever likely to get.  You could use L1_CACHE_BYTES instead
> I suppose.
> 
> > What would you expect? The linker script language is quite limited in
> > its capabilities... Best I could do is split the ".broken" section into
> > several sections and move the descriptions from the individual comments
> > above here. If this muckle of empty ".broken.*" sections gets correctly
> > discarded and triggers no bug in binutils, I can probably do it.
> 
> Adding more sections and section names unnecessarily bloats the size of the
> vDSO image.  Keep the set of output sections to the necessary minimum.

Which version of binutils are you using? I'm using binutils-2.19, and
all empty sections get completely discarded, i.e. they do not affect the
size of the output in any way.

Petr Tesarik


