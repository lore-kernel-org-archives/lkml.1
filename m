Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYIYRqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYIYRqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIYRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:46:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYIYRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:46:38 -0400
Date: Thu, 25 Sep 2008 13:46:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/2 v2] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809251023090.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251342330.29802@gandalf.stny.rr.com>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251312010.27920@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0809251023090.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Linus Torvalds wrote:
> On Thu, 25 Sep 2008, Steven Rostedt wrote:
> > 
> > The problem with this is overwrite mode, which is the only mode ftace 
> > currently offers. What happens when your writer starts overwriting the 
> > ring buffer and there is no reader?
> 
> Overwrite things on page at a time. Don't you already do that? (I didn't 
> check that closely, I just assumed you would do the _much_ simpler "move 
> the head to the next page" thing rather than trying to mix head and tail 
> on the same page.

Yeah, I decided to do the blast the page instead of just blast the entry.
This keeps complexity a hell of a lot simpler.

> 
> > What happens is that the start value is gone. You do not have a way to use 
> > all the deltas to catch up to the remaining events.
> 
> Use the page start date for the first event in a page. But within pages, 
> make everything depend on previous event.

Hmm, I'm confused. I do this already. I put the page start time on each 
page already. The events on the page are based on the page start time
itself.  The iterator, or writer, keeps track of the last event. When it 
reaches a new page, it reads the new time stamp of the page and starts 
incrementing against that.

-- Steve

