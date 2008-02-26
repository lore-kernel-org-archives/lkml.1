Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbYBZSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbYBZSG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYBZSGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:06:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60078 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYBZSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:06:17 -0500
Date: Tue, 26 Feb 2008 19:06:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, bill.huey@gmail.com,
       rostedt@goodmis.org, kevin@hilman.org, tglx@linutronix.de,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       Moiz Kohari <MKohari@novell.com>, Peter Morreale <PMorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, dsaxena@plexity.net,
       acme@redhat.com, ak@suse.de, gregkh@suse.de, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [(RT RFC) PATCH v2 5/9] adaptive real-time lock support
Message-ID: <20080226180643.GA6030@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160103.11268.25579.stgit@novell1.haskins.net> <20080225220313.GG2659@elf.ucw.cz> <47C3E3FF.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C3E3FF.BA47.005A.0@novell.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 08:03:43, Gregory Haskins wrote:
> >>> On Mon, Feb 25, 2008 at  5:03 PM, in message
> <20080225220313.GG2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> 
> >> +static inline void
> >> +prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter 
> > *adaptive)
> > ...
> >> +#define prepare_adaptive_wait(lock, busy) {}
> > 
> > This is evil. Use empty inline function instead (same for the other
> > function, there you can maybe get away with it).
> > 
> 
> I went to implement your suggested change and I remembered why I did it this way:  I wanted a macro so that the "struct adaptive_waiter" local variable will fall away without an #ifdef in the main body of code.  So I have left this logic alone for now.

Hmm, but inline function will allow dead code elimination,  too, no?

Anyway non-evil way to do it with macro is 

#define prepare_adaptive_wait(lock, busy) do {} while (0)

...that behaves properly in complex statements.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
