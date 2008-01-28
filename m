Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYA1Tku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYA1Tku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbYA1Tkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:40:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1718 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761011AbYA1Tkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:40:41 -0500
Date: Mon, 28 Jan 2008 19:40:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Message-ID: <20080128194017.GA4481@ucw.cz>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801252302.52164.rjw@sisk.pl> <20080128150022.GE27928@elte.hu> <200801281625.45165.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801281625.45165.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  /*
> > >   * Swap suspend & friends need this for resume because things like the intel-agp
> > >   * driver might have split up a kernel 4MB mapping.
> > >   */
> > > -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> > > +char swsusp_pg_dir[PAGE_SIZE]
> > 
> > thanks, applied.

Sorry, this is subtle and I've overlooked it before.

(I thought you were only changing ifdef).

Now you memcpy() over pg_dir when that pgdir is in use during swsusp
resume. Granted, you memcpy() with same data that already are there,
but it may still do some funny effects.

Hmm, but same argument applies to lower levels of paging in 64-bit and
PAE cases, and we still do that memcpy-over-active-pagetables there...
:-(.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
