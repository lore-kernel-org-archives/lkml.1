Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYFRMNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYFRMNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYFRMNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:13:40 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:21017 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYFRMNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:13:39 -0400
Message-Id: <4858C3B9.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 06:13:45 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Marin Mitov" <mitov@issp.bas.bg>,
       "Gregory Haskins" <GHaskins@novell.com>
Cc: "Andi Kleen" <andi-suse@firstfloor.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, <akpm@osdl.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
References: <200805252108.25011.mitov@issp.bas.bg>
 <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu>
 <200806152058.17142.mitov@issp.bas.bg> <20080618075518.GD4135@elte.hu>
 <4858C286.BA47.005A.0@novell.com>
In-Reply-To: <4858C286.BA47.005A.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jun 18, 2008 at  8:08 AM, in message <4858C286.BA47.005A.0@novell.com>,
"Gregory Haskins" <ghaskins@novell.com> wrote: 
>>>> On Wed, Jun 18, 2008 at  3:55 AM, in message <20080618075518.GD4135@elte.hu>,
> Ingo Molnar <mingo@elte.hu> wrote: 
> 
>> * Marin Mitov <mitov@issp.bas.bg> wrote:
>> 
>>> Why not something like that (do keep in mind I am not an expert :-):
>>> 
>>> static void delay_tsc(unsigned long loops)
>>> {
>>> 	get and store the mask of allowed cpus;
>>> 	/*     prevent the migration   */
>>> 	set the mask of allowed cpus to the current cpu only;
>>> 	/*     is it possible? could it be guaranteed?    */
>>> 	loop for the delay;
>>> 	restore the old mask of allowed cpus;
>>> }
>>> 
>>> You have got the idea. Could it be realized? Is it more expensive than 
>>> the current realization? So, comments, please.
>> 
>> hm, changing/saving/restorig cpus_allowed is really considered a 'heavy' 
>> operation compared to preempt_disable(). On a 4096 CPUs box cpus_allowed 
>> is 4096 bits which is half a kilobyte ...
>> 
>> preempt_disable()/enable() on the other hand only touches a single 
>> variable, (thread_info->preempt_count which is an u32)
>> 
>> 	Ingo
> 
> FWIW:  I had submitted some "migration disable" patches a while back that 
> would solve this without the cpus_allowed manipulations described here.  Its 
> more expensive than a preempt-disable (but its preemptible), yet its way 
> cheaper (and more correct / less racy) than chaning cpus_allowed.  I could 
> resubmit if there was any interest, though I think Ingo said he didnt like 
> the concept on the first pass.  Anyway, FYI.

Sorry, should have provided a reference:

http://lkml.org/lkml/2008/2/12/344

> 
> -Greg
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


