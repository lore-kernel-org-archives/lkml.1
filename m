Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXGGFGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXGGFGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 01:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXGGFFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 01:05:54 -0400
Received: from 1wt.eu ([62.212.114.60]:3290 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXGGFFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 01:05:53 -0400
Date: Sat, 7 Jul 2007 07:02:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mbligh@google.com
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707050214.GA943@1wt.eu>
References: <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706234315.GA19804@Krystal> <20070707022526.GC3492@stusta.de> <20070707023511.GA25778@Krystal> <20070707040307.GD3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707040307.GD3492@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 06:03:07AM +0200, Adrian Bunk wrote:
> On Fri, Jul 06, 2007 at 10:35:11PM -0400, Mathieu Desnoyers wrote:
> > * Adrian Bunk (bunk@stusta.de) wrote:
> > > On Fri, Jul 06, 2007 at 07:43:15PM -0400, Mathieu Desnoyers wrote:
> > > > * Adrian Bunk (bunk@stusta.de) wrote:
> > > > > On Fri, Jul 06, 2007 at 06:14:10PM -0400, Chuck Ebbert wrote:
> > > > > > On 07/06/2007 07:44 AM, Andi Kleen wrote:
> > > > > > > I think the optimization is a good idea, although i dislike it
> > > > > > > that it is complicated for the dynamic markers. If it was just
> > > > > > > static it would be much simpler.
> > > > > > 
> > > > > > Another thing to consider is that there might be hundreds of these
> > > > > > probes/tracepoints active in an instrumented kernel. The overhead
> > > > > > adds up fast, so the gain may be worth all the pain.
> > > > > 
> > > > > Only if you want to squeeze the last bit of performance out of
> > > > > _debugging_ functionality.
> > > > > 
> > > > > You avoid all the pain if you simply don't use debugging functionality 
> > > > > on production systems.
> > > > > 
> > > > 
> > > > Adrian,
> > > > 
> > > > Please have a look at my markers posts, especially:
> > > > 
> > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/0669.html
> > > > 
> > > > And also look into OLS 2007 proceedings for Martin Bligh's paper on
> > > > Debugging Google sized clusters. It basically makes the case for adding
> > > > functionnality to debug _user space_ problems on production systems that
> > > > can be turned on dynamically.
> > > 
> > > Using a different kernel for tracing still fulfills all the requirements 
> > > listed in section 5 of your paper...
> > > 
> > 
> > Not exactly. I assume you understand that rebooting 1000 live production
> > servers to find the source of a rare bug or the cause of a performance
> > issue is out of question.
> > 
> > Moreover, strategies like enabling flight recorder traces on a few nodes
> > on demand to detect performance problems can only be deployed in
> > production environment if they are part of the standard production
> > kernel.
> > 
> > Also, managing two different kernels is often out of question. Not only
> > is it a maintainance burden, but just switching to the "debug" kernel
> > can impact the system's behavior so badly that it could make the problem
> > disappear.
> 
> As can turning tracing on at runtime.
> 
> And you can always define requirements in a way that your solution is 
> the only one...

On large production environments, you always lose a certain percentage of
machines at each reboot. Most often, it's the CR2032 lithium battery which
is dead and which causes all or parts of the CMOS settings to vanish, hanging
the system at boot. Then you play with the ON/OFF switch and a small
percentage of the power supplies refuse to restart and some disks refuse
to spin up.

Fortunately this does not happen with all machines, but if you have such
problems with 1% of your machines, you lose 10 machines when you reboot
1000 of them. Those problems require a lot of man power, which explains
why such systems are rarely updated.

Causing that much trouble just to enable debugging is clearly
unacceptable, and your debug kernel will simply never be used. Not to
mention the fact that people will never trust it because it's almost
never used !

Regards,
Willy

