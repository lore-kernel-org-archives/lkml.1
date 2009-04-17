Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZDQQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZDQQDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZDQQDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:03:12 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46922 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbZDQQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:03:11 -0400
Date: Fri, 17 Apr 2009 11:55:50 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <20090417153520.GA29968@elte.hu>
Message-ID: <alpine.DEB.1.10.0904171142050.13734@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop>
 <alpine.DEB.1.10.0904171100510.21575@qirst.com> <20090417153520.GA29968@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux.com> wrote:
>
> > On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> >
> > > And a random 1us cutoff, is well, random.
> >
> > Its got to be somewhere.
>
> Sorry, that's not a rational answer that makes any sense.

There must be criteria for what constitutes a interrupt of the user space
application that we care about. There are numerous effects (like cacheline
fetches etc) that also cause holdoffs. So its not only the OS. There are
also other randomizing influences due to the exact location in the
measurement code path where the interrupt occurred. The criterion used
here was that the cpu was not executing code for longer than 1 usec. We
can discuss if this makes sense or what makes sense. But the measurements
here are entirely from the perspective of the user space program
experiencing OS noise.

> Peter's point is statistics 101: please show absolute values not an
> event distribution cutoff - how much total time do we spend in the
> kernel in that workload?

Futher details are included in the document that I pointed him to. The
"workload" is a synthetic test of a busy loop continually reading the TSC
register.

http://www.kernel.org/pub/linux/kernel/people/christoph/collab-spring-2009/Latencharts.ods

> Is the overhead 1%? 2%? 0.5%? And how did it change from 2.6.22
> onwards? Did it go up by 0.1%, from 1% to 1.1%? Or did the average
> go down by 0.05%, while increasing the spread of events (thus
> fooling your cutoff)?

As you see in the diagrams provided there is a 4 fold increase in the
number of interrupts >1usecs when going from 2.6.22 to 2.6.23. How would
you measure the overhead? Time spent in the OS? Disturbance of the caches
by the OS that cause the application to have to refetch data from Ram?

> These are very simple, very basic, very straightforward questions -
> and no straight answer was forthcoming from you. Are you not
> interested in that answer?

Is this goofiness going to continue? I provided measurements from a user
space perspective and you keep on demanding that I take other
measurements. I can dig deeper into the reasons for these regressions and
we can discuss what would be useful to measure but that wont happen
overnight.
