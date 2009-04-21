Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZDUVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZDUVd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZDUVdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:33:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZDUVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:33:43 -0400
Date: Tue, 21 Apr 2009 17:33:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@elastic.org>
cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jiaying Zhang <jiayingz@google.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
In-Reply-To: <20090421212347.GC402@elastic.org>
Message-ID: <alpine.DEB.2.00.0904211728310.10097@gandalf.stny.rr.com>
References: <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org>
 <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil> <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com> <20090421212347.GC402@elastic.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ removed Pekka@firstfloor.org due to mail errors ]

On Tue, 21 Apr 2009, Frank Ch. Eigler wrote:

> Hi -
> 
> On Tue, Apr 21, 2009 at 05:17:17PM -0400, Steven Rostedt wrote:
> 
> > [...]  Perhaps we should fork off gcc and ship Linux with its own
> > compiler. This way we can optimize it for the kernel and not worry
> > about any userland optimizations.
> 
> In this regard, kernel land does not seem that unlike user land.
> 
> > 	if (unlikely(err)) {
> > 		__section__(".error_sect") {
> > 			/* put error code here */
> > 		}
> > 	}
> > 
> > And have gcc in the error section (if it is big enough perhaps) do:
> > 	jmp .L123
> > .L124   [...]
> > [...]
> > 	jmp .L124
> 
> > We could do the same for trace points. That is, any part of code that 
> > really would happen once in a while (error handling for one) we can move 
> > off to its own section and keep hot paths hot.
> 
> This is called -freorder-blocks or -freorder-blocks-and-partition
> (depending on how far you would like gcc to move unlikely blocks).

That does not let us pick and choose what and where to put the code.

But still, a fork of gcc would let us optimize it for the kernel, and not 
for generic programs.

/me has been sitting too close to the furnace and must have been taking 
up some of those fumes, to be considering a fork of gcc a good idea ;-)

-- Steve

