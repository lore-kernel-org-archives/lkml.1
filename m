Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYI3Py4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYI3Py4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYI3Pyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:54:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:35693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYI3Pys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:54:48 -0400
Subject: Re: [PATCH v10 Golden] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20080930092001.69849210@bike.lwn.net>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>
	 <20080929233539.GA31143@Krystal>
	 <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
	 <20080930000307.GA2929@Krystal>
	 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
	 <20080930034603.GA13801@Krystal>
	 <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
	 <20080930092001.69849210@bike.lwn.net>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 17:54:32 +0200
Message-Id: <1222790072.24384.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 09:20 -0600, Jonathan Corbet wrote:
> On Tue, 30 Sep 2008 00:00:11 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ah, I believe the disk IO uses the page frame. That might be a bit more 
> > difficult to pass the data to disk and still keep information on the
> > page frame.
> 
> Perhaps I'm speaking out of turn, but I have to wonder: am I the only one
> who gets uncomfortable looking at these hacks to overload struct page?  It
> seems fragile as all hell; woe to he who tries to make a change to struct
> page someday and has to track all of this stuff down.
> 
> Are the savings gained by using struct page this way really worth the
> added complexity?

Its not that complex IMHO, the thing that is ugly are those struct page
overloads, what we could do is try and sanitize the regular struct page
and pull all these things in.

Because the only reason people are doing these overloads is because
struct page in mm_types.h is becomming an unreadable mess.

Trouble is, looking at it I see no easy way out,

