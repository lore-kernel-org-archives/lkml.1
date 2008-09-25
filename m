Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYIYRc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYIYRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYIYRcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:32:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbYIYRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:32:14 -0400
Date: Thu, 25 Sep 2008 10:25:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
In-Reply-To: <alpine.DEB.1.10.0809251312010.27920@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809251023090.3265@nehalem.linux-foundation.org>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251312010.27920@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Steven Rostedt wrote:
> 
> The problem with this is overwrite mode, which is the only mode ftace 
> currently offers. What happens when your writer starts overwriting the 
> ring buffer and there is no reader?

Overwrite things on page at a time. Don't you already do that? (I didn't 
check that closely, I just assumed you would do the _much_ simpler "move 
the head to the next page" thing rather than trying to mix head and tail 
on the same page.

> What happens is that the start value is gone. You do not have a way to use 
> all the deltas to catch up to the remaining events.

Use the page start date for the first event in a page. But within pages, 
make everything depend on previous event.

		Linus
