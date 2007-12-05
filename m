Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbXLOHz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbXLOHz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXLOHzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:55:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2062 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbXLOHzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:55:16 -0500
Date: Wed, 5 Dec 2007 16:30:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071205163017.GA4756@ucw.cz>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <20071204193432.GI11764@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204193432.GI11764@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-12-04 20:34:32, Andi Kleen wrote:
> On Tue, Dec 04, 2007 at 09:18:33PM +0200, Avi Kivity wrote:
> > Glauber de Oliveira Costa wrote:
> >> This patch moves the i386 control registers manipulation functions,
> >> wbinvd, and clts functions to system.h. They are essentially the same
> >> as in x86_64, except for the cr8 register, which we add.
> >>
> >> +
> >> +static inline unsigned long native_read_cr8(void)
> >> +{
> >> +	unsigned long cr8;
> >> +	asm volatile("mov %%cr8,%0" : "=r" (cr8), "=m" (__force_order));
> >> +	return cr8;
> >> +}
> >> +
> >>   
> >
> > There is no cr8 register on i386.  This had better be protected by an 
> > #ifdef.
> >
> > (you're likely not getting an error since it's a static inline, so the asm 
> > is never emitted)
> 
> Linux never uses that register. The only user is suspend save/restore, 
> but that' bogus because it wasn't ever initialized by Linux in the first
> place. It could be probably all safely removed.

It probably is safe to remove... but we currently support '2.8.95
kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses
cr8.

So please keep it if it is not a big problem.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
