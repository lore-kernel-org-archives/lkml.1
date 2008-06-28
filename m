Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYGFOrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYGFOrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbYGFOrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:47:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2653 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757222AbYGFOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:47:37 -0400
Date: Sat, 28 Jun 2008 12:44:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marin Mitov <mitov@issp.bas.bg>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Message-ID: <20080628104453.GC10872@ucw.cz>
References: <200805252108.25011.mitov@issp.bas.bg> <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu> <200806152058.17142.mitov@issp.bas.bg> <20080618075518.GD4135@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618075518.GD4135@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-18 09:55:18, Ingo Molnar wrote:
> 
> * Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > Why not something like that (do keep in mind I am not an expert :-):
> > 
> > static void delay_tsc(unsigned long loops)
> > {
> > 	get and store the mask of allowed cpus;
> > 	/*     prevent the migration   */
> > 	set the mask of allowed cpus to the current cpu only;
> > 	/*     is it possible? could it be guaranteed?    */
> > 	loop for the delay;
> > 	restore the old mask of allowed cpus;
> > }
> > 
> > You have got the idea. Could it be realized? Is it more expensive than 
> > the current realization? So, comments, please.
> 
> hm, changing/saving/restorig cpus_allowed is really considered a 'heavy' 
> operation compared to preempt_disable(). On a 4096 CPUs box cpus_allowed 
> is 4096 bits which is half a kilobyte ...

Time to RLE the bitmap? 

<runs>							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
