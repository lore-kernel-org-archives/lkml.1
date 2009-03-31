Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZCaL2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZCaL2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZCaL2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:28:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:37724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZCaL2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:28:08 -0400
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, oleg@redhat.com, adobriyan@gmail.com,
       mingo@elte.hu, torvalds@linux-foundation.org, fche@redhat.com,
       roland@redhat.com, rostedt@goodmis.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>, Jeff Dike <jdike@addtoit.com>
In-Reply-To: <1238491062.28248.2046.camel@twins>
References: <20090321041954.72b99e69.akpm@linux-foundation.org>
	 <20090321115141.GA3566@redhat.com>
	 <20090321050422.d1d99eec.akpm@linux-foundation.org>
	 <20090321154501.GA2707@elte.hu>
	 <20090321143413.75ead1aa.akpm@linux-foundation.org>
	 <20090321215145.GB5262@redhat.com>
	 <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
	 <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain>
	 <20090323151400.GA3413@redhat.com> <20090323214417.GD5814@mit.edu>
	 <20090330151844.8b4eed0f.akpm@linux-foundation.org>
	 <1238491062.28248.2046.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Mar 2009 13:27:56 +0200
Message-Id: <1238498876.27156.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 11:17 +0200, Peter Zijlstra wrote:
> On Mon, 2009-03-30 at 15:18 -0700, Andrew Morton wrote:
> > So we need to work out what to do about utrace and I feel a need to hit
> > the reset button on all this.  Largely because I've forgotten
> > everything and it was all confusing anyway.
> 
> Right, from my POV something like utrace is desirable, since its
> basically a huge multiplexer for the debugger state, eventually allowing
> us to have multiple debuggers attached to the same process.
> 
> So in that respect its a very nice feature.
> 
> > Could those who object to utrace please pipe up and summarise their
> > reasons?
> 
> Christoph used to have an opinion on this matter, so I've added him to
> the CC.
> 
> Last time when I looked at the code, it needed a bit more care and
> comments wrt lifetimes and such. I know Roland has done a lot on that
> front -- so I'll need to re-inspect.
> 
> As to in-kernel users, currently we only have ptrace, and no full
> conversion to utrace is in a mergeable shape afaik.
> 
> UML (Jeff CC'ed) might want to use this.
> 
> I know the Systemtap people need this (fche). But that isn't really
> moving towards mainline any time soon afaict.
> 
> Then there is this little thing called frysk which uses it, no idea what
> kind of kernel space that needs, nor where it lives -- or for that
> matter, wth it really does ;-)

And Frank reminded me we have an ftrace tracer that utilizes utrace.

> Anyway, long story short, once people have had a little time to go over
> the code, and a few in-kernel users are lined-up, I think we should
> consider merging it.
