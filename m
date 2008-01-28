Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbYA1VBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbYA1VBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYA1VBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:01:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYA1VBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:01:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 21:59:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801282126.45751.rjw@sisk.pl> <479E3B89.20101@zytor.com>
In-Reply-To: <479E3B89.20101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282159.19616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > On Monday, 28 of January 2008, Pavel Machek wrote:
> >> Hi!
> >>
> >>>>>  /*
> >>>>>   * Swap suspend & friends need this for resume because things like the intel-agp
> >>>>>   * driver might have split up a kernel 4MB mapping.
> >>>>>   */
> >>>>> -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> >>>>> +char swsusp_pg_dir[PAGE_SIZE]
> >>>> thanks, applied.
> >> Sorry, this is subtle and I've overlooked it before.
> >>
> >> (I thought you were only changing ifdef).
> >>
> >> Now you memcpy() over pg_dir when that pgdir is in use during swsusp
> >> resume.
> > 
> > It is not.  swsusp hasn't been using swsusp_pg_dir for several months.
> > Hence, the patch. :-)
> > 
> >> Granted, you memcpy() with same data that already are there, 
> >> but it may still do some funny effects.
> >>
> >> Hmm, but same argument applies to lower levels of paging in 64-bit and
> >> PAE cases, and we still do that memcpy-over-active-pagetables there...
> >> :-(.
> > 
> > Actually, no.  We only do that with the kernel code mapping which should be
> > safe as long as TLBs are not flushed (and they aren't).
> > 
> 
> Okay... does that in any way affect using the kernel code mapping 
> synchronization code to maintain a set of trampoline pagetables?

I really don't think so.

Rafael
