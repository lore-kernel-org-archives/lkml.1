Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXGPJCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXGPJCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXGPJCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:02:05 -0400
Received: from web26902.mail.ukl.yahoo.com ([217.146.176.91]:36529 "HELO
	web26902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754784AbXGPJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:02:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1YxfL6dS2KxxeKDKnXB7ErVx0Cmaq/OEMoEBozOuSRXEpJ0/cFLlIGstG+Z5gFEEi3+3lhLWgJXax0gMXZrz6brv3RMfM7J7+KKNsAv0tXpow8akQcj1mrl5z3LAqFvR5A+h2ae/H9o5lb+DirrAaoFGF25RmmHV97NRvDxZqsI=;
X-YMail-OSG: M1178noVM1ke.6qDR0.7k3E7yNxZf0NtuaQr2cP9PM5KUmOOnvyL_3kzbJJSFiA3_iIW.A--
Date: Mon, 16 Jul 2007 11:02:01 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Re: RE : Re: x86 setup code rewrite in C - revised
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4697EC66.2030404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <217644.17566.qm@web26902.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "H. Peter Anvin" <hpa@zytor.com> wrote:
> >>>>  - Does not save and restore %ds when printing a char on the screen (%ds is
> >>>>  destroyed only when the content of the screen scroll - only for some video cards)
> >> %ds?  Aren't you confusing it with the old bug which would destroy %bp?
> >>  If you have any references to %ds being destroyed I would be very
> >> surprised.  I can guarantee that very little if any assembly code I've
> >> ever seen that deals with INT 10h -- and I've seen a lot of it -- guards
> >> against %ds being randomly trashed.
> >>
> >> However, the trashing of %bp is a well-known bug (although only for
> >> machines older than the ones that can run Linux) -- the Interrupt List has:
> >>
> >> BUGS:   some implementations (including the original IBM PC) have a bug
> >>  	which destroys BP
> > 
> >  That is on Trident cards, old card but may still be used, and BIOS may have
> > been copied to other cards.
> >  Detected and documented on Gujin (boot.c and vgabios.h scroll)
> 
> Are you talking about BP or DS?  As I said, the BP is well-known, and
> the code accounts for it in the form of the INT10 macro.

 Extract of RBIL61:
INT 10 - VIDEO - SCROLL UP WINDOW
	AH = 06h
	AL = number of lines by which to scroll up (00h = clear entire window)
	BH = attribute used to write blank lines at bottom of window
	CH,CL = row,column of window's upper left corner
	DH,DL = row,column of window's lower right corner
Return: nothing
Note:	affects only the currently active page (see AH=05h)
BUGS:	some implementations (including the original IBM PC) have a bug which
	  destroys BP
	the Trident TVGA8900CL (BIOS dated 1992/9/8) clears DS to 0000h when
	  scrolling in an SVGA mode (800x600 or higher)

 Scrolling is only (and automatically) done if the cursor is at bottom right.

> >>>>  Also, I do not know if "m" is right in here:
> >>>> static inline u8 rdfs8(addr_t addr)
> >>>> {
> >>>> 	u8 v;
> >>>> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
> >>>> 	return v;
> >>>> }
> >> The "m" is correct right there.
> > 
> >  strange, "g" would mean anything can go there - and this assembly instruction
> > should accept every access modes.
> 
> Not with an %fs: prefix.  It would also allow the compiler to do a move
> into a register "on its own", which would be disastrous, since it would
> lack the prefix.  So "m" is correct.

  "mov %fs:(%ebx,%eax,4),%ecx" works for me.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
