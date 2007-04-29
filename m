Return-Path: <linux-kernel-owner+w=401wt.eu-S1161558AbXD2Xdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161558AbXD2Xdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161559AbXD2Xdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:33:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63810 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbXD2Xds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:33:48 -0400
Date: Sun, 29 Apr 2007 16:37:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070429163701.fb994561.randy.dunlap@oracle.com>
In-Reply-To: <20070428172154.GA11115@waste.org>
References: <20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070428161136.GL11166@waste.org>
	<20070428171101.GC20646@redhat.com>
	<20070428172154.GA11115@waste.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 12:21:54 -0500 Matt Mackall wrote:

> On Sat, Apr 28, 2007 at 01:11:01PM -0400, Dave Jones wrote:
> > On Sat, Apr 28, 2007 at 11:11:36AM -0500, Matt Mackall wrote:
> >  > > I'm all ears for additional regexps, bug reports or other suggestions.
> >  > 
> >  > Neat.
> >  > 
> >  > Does it check for:
> >  > 
> >  > functions marked extern?

	data marked extern?

> >  > pulling in external functions or variables without a header file?
> >  > return used as a function, eg return(foo);?
> > 
> > These sound a little more tricky than just dumb regexps.
> > I don't want to expand this to a fullblown C parser (given
> > that we have sparse which can do a better job), but I don't
> > object to adding some extra code to give the searches more
> > context.
> 
> The first is a straightforward one-line regexp, as is the last:
> 
> ^extern \w.*\w\(

Just omit the ending \( to catch functions or data.
Added.

> return\s?\(

Added.  Thanks.

> The middle one is a bit trickier. Basically, we don't want people
> doing either:
> 
> extern int capital_of_assyria;
> int sir_not_appearing_in_this_module();
> 
> in .c files. The first of those two is easy, provided you can figure
> out the file type. And both are possible with multiline regexps.
> 
> This whole thing would be quite a bit more powerful if your search
> function joined all the lines together, did a potentially multiline
> search, then calculated the line numbers from the search results. Then
> you could search for things like:
> 
> if (...)
> {
> 
> if (...) {
>   single_statement;
> }
> 
> Looking forward to fully-automated pedantry. This should probably live
> in scripts/.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
