Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYJARu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYJARu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYJARuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:50:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYJARuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:50:11 -0400
Date: Wed, 1 Oct 2008 13:49:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
In-Reply-To: <20081001173653.GA14538@Krystal>
Message-ID: <alpine.DEB.1.10.0810011342340.2504@gandalf.stny.rr.com>
References: <20080930000307.GA2929@Krystal> <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
 <20081001173653.GA14538@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Mathieu Desnoyers wrote:
> 
> I understand that you want to allocate these struct buffer_page in
> memory local to a given cpu node, which is great, but why do you feel
> you need to align them on cache_line_size() ?
> 
> Hrm.. you put the timestamp in there, so I guess you're concerned about
> having a writer on one CPU, a reader on another, and the fact that you
> will have cache line bouncing because of that.
> 
> Note that if you put the timestamp and the unused bytes in a tiny header
> at the beginning of the page, you
> 
> 1 - make this information directly accessible for disk, network I/O
> without any other abstraction layer.
> 2 - won't have to do such alignment on the struct buffer_page, because
> it will only be read once it's been allocated.
> 

That was the approach I actually started with. But someone (I think
Peter) asked me to remove it.

Who knows, perhaps I can put it back. It's not that hard to do. This is
why I used BUF_PAGE_SIZE to determine the size of the buffer page.
Right now it BUF_PAGE_SIZE == PAGE_SIZE, but if we do add a header than
it will be BUF_PAGE_SIZE == PAGE_SIZE - sizeof(header)

-- Steve

