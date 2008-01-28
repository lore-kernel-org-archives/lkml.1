Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYA1U3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYA1U3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYA1U2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:28:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYA1U2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:28:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 21:26:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz>
In-Reply-To: <20080128194017.GA4481@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282126.45751.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Pavel Machek wrote:
> Hi!
> 
> > > >  /*
> > > >   * Swap suspend & friends need this for resume because things like the intel-agp
> > > >   * driver might have split up a kernel 4MB mapping.
> > > >   */
> > > > -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> > > > +char swsusp_pg_dir[PAGE_SIZE]
> > > 
> > > thanks, applied.
> 
> Sorry, this is subtle and I've overlooked it before.
> 
> (I thought you were only changing ifdef).
> 
> Now you memcpy() over pg_dir when that pgdir is in use during swsusp
> resume.

It is not.  swsusp hasn't been using swsusp_pg_dir for several months.
Hence, the patch. :-)

> Granted, you memcpy() with same data that already are there, 
> but it may still do some funny effects.
> 
> Hmm, but same argument applies to lower levels of paging in 64-bit and
> PAE cases, and we still do that memcpy-over-active-pagetables there...
> :-(.

Actually, no.  We only do that with the kernel code mapping which should be
safe as long as TLBs are not flushed (and they aren't).

Thanks,
Rafael
