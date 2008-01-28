Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYA1P2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYA1P2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYA1P1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:27:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYA1P1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:27:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 16:25:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801252302.52164.rjw@sisk.pl> <20080128150022.GE27928@elte.hu>
In-Reply-To: <20080128150022.GE27928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281625.45165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Speaking of cleanups, the following one is applicable IMO.
> 
> > --- linux-2.6.orig/arch/x86/mm/init_32.c
> > +++ linux-2.6/arch/x86/mm/init_32.c
> > @@ -444,23 +444,23 @@ static void __init pagetable_init (void)
> >  	paravirt_pagetable_setup_done(pgd_base);
> >  }
> >  
> > -#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
> > +#ifdef CONFIG_SUSPEND
> >  /*
> >   * Swap suspend & friends need this for resume because things like the intel-agp
> >   * driver might have split up a kernel 4MB mapping.
> >   */
> > -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> > +char swsusp_pg_dir[PAGE_SIZE]
> 
> thanks, applied.

Thanks.  Well, the comment should also be updated as I can see now.  I'll send
a separate patch for that.

Rafael
