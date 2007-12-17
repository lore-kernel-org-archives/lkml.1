Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXLQAXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXLQAXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759998AbXLQAXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:23:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53548 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759815AbXLQAXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:23:08 -0500
Date: Mon, 17 Dec 2007 01:23:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071217002306.GD5692@elf.ucw.cz>
References: <11967843881946-git-send-email-gcosta@redhat.com> <20071205163017.GA4756@ucw.cz> <20071215131723.GF9720@elte.hu> <200712170127.31615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712170127.31615.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-17 01:27:29, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > Linux never uses that register. The only user is suspend 
> > > > save/restore, but that' bogus because it wasn't ever initialized by 
> > > > Linux in the first place. It could be probably all safely removed.
> > > 
> > > It probably is safe to remove... but we currently support '2.8.95 
> > > kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses 
> > > cr8.
> > > 
> > > So please keep it if it is not a big problem.
> > 
> > hm, so __save_processor_state() is in essence an ABI? Could you please 
> > also send a patch that documents this prominently, in the structure 
> > itself?
> 
> Hmm, I'm not sure if it really is an ABI part.  It doesn't communicate anything
> outside of the kernel in which it is defined.

Well, it is not "application binary interface", but it is
"kernel-to-kernel binary interface"...

> The problem is, though, that if kernel A is used for resuming kernel B, and
> kernel B doesn't save/restore everything it will need after the resume, then
> things will break if kernel A modifies that.  So, yes, we'll need to document
> that explicitly.

Agreed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
