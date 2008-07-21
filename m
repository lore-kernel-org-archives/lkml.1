Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYGUOFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYGUOFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYGUOFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:05:05 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53177 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYGUOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:05:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18564.38760.212333.375520@harpo.it.uu.se>
Date: Mon, 21 Jul 2008 16:04:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PIC, L-APIC and I/O APIC debug information
In-Reply-To: <Pine.LNX.4.55.0807211222250.23386@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
	<18563.55832.673541.202465@harpo.it.uu.se>
	<Pine.LNX.4.55.0807211222250.23386@cliff.in.clinika.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki writes:
 > On Mon, 21 Jul 2008, Mikael Pettersson wrote:
 > 
 > >  > +#define __apicdebuginit(type) static type __init
 > > ...
 > >  > -void __init print_IO_APIC(void)
 > >  > +
 > >  > +__apicdebuginit(void) print_IO_APIC(void)
 > >  >  {
 > > 
 > > I _really_ dislike how this abuses the C macro preprocessor
 > > to create pointless new syntax.
 > > 
 > > Since you're editing these function definitions anyway why
 > > not just spell out "static void __init" in readable proper C?
 > 
 >  This is so that while debugging you can make all these functions global
 > with a single change in one place, rather than going through the whole
 > file and finding all the relevant function headers.  Presumably the
 > original reason for the existence of the macro.  Unfortunately an
 > object-like macro cannot be used here, as the "static" keyword has to come
 > first in a function declaration and the section attribute has to come
 > after the type designation.
 > 
 >  What's wrong with the syntax in your opinion?

It's not even remotely C-like, which will cause confusion
for anyone or anything trying to read and understand the code.

(Basically you're on the path to PL/1 or Bourne C, neither of
which were great from a software engineering point of view.)

Something like the following looks saner to me, would it work for you?

	#ifdef debug
	#define apicdebug	/* empty */
	#define __apicinit	/* empty */
	#else
	#define apicdebug	static
	#define __apicinit	__init
	#endif
	...
	apicdebug void __apicinit print_IO_APIC(void)
	{ .. }

/Mikael
