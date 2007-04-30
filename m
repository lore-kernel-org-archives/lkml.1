Return-Path: <linux-kernel-owner+w=401wt.eu-S1946582AbXD3Sm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946582AbXD3Sm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946589AbXD3Sm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:42:26 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:2545 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946582AbXD3SmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MKEg7nUo8W690hDbiDkQEi9/vbD26biW5vv4uUdGn6G44EWt0zkER30OTUCaNYqt+ciRIhC+WdTn6SvBG30fADqKbLEjpfxY7YYEAVSlfo7fCCePnxflq+Hf2+1W0aIN2C+BWSv0ZDUSitoXCCzJS3RLVT3r8zGm+FaMUY7seDo=
Message-ID: <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
Date: Tue, 1 May 2007 00:12:21 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: condingstyle, was Re: utrace comments
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Roland McGrath" <roland@redhat.com>, "Christoph Hellwig" <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070430100917.439ebfc8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061127165138.GA2991@lst.de>
	 <20070430040213.BF9901801A4@magilla.sf.frob.com>
	 <20070430091121.GC31397@infradead.org>
	 <20070430100917.439ebfc8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 30 Apr 2007 10:11:21 +0100 Christoph Hellwig <hch@infradead.org> wrote:
>
> > I've separated this out under a new subject because some style issues
> > that so far aren't documented explicitly are in doubt here, and Roland
> > wants and Answer from Andrew.
> >
> > We also should put clauses on this into CodingStyle.
> >
> >
> > On Sun, Apr 29, 2007 at 09:02:13PM -0700, Roland McGrath wrote:
> > > >   The coding style here is wrong.  The else should be on the line
> > > >   of the closing brace.
> > >
> > > I can ordinarily ignore syntax, but this is an abomination in the sight
> > > of the Lord and always will be.  Fortunately, it's far from being 100%
> > > consistently used in the kernel already.  People are welcome to change
> > > the code after I submit it, but I just can't make myself write it that
> > > way, sorry.
>
> I'm a bit lost here.  Are we referring to
>
>         if (expr) {
>                 ...
>         } else {
>                 ...
>         }
>
> versus
>
>         if (expr) {
>                 ...
>         }
>         else {
>                 ...
>         }
>
> ?
>
> If so the former is usual style.  People do add code which does the latter,
> but it tends to get fixed up later on when someone else does some work on
> the same code.

Documentation/CodingStyle is indeed a bit ambiguous w.r.t. this. It does
mention what Andrew is saying here: a closing brace always on a line of its
own _except_ that an "else" may appear immediately after the closing brace
of the previous statement block in if-else statements. Unfortunately, this goes
against the example given in K&R Section 3.2 and the example given to
illustrate this in CodingStyle itself shows a multiple-condition
if-else-if statement,
not a single-condition if-else (and K&R do treat if-else-if's differently than
if-else's for indentation purposes). No harm in continuing to stick to the usual
style, of course, as K&R are not consistent about this themselves.

> > > >   This doesn't follow kernel coding style at all, we always
> > > >   put the && or || operators at the end of the closing line.
> > >
> > > I could swear I've been "corrected" in the opposite direction on this one.
> > > It is not mentioned in Documentation/CodingStyle, and the existing kernel
> > > code is far from consistent on it.  I really don't care which way it is,
> > > but I'd like clear authoritative direction from Linus and Andrew before I
> > > bother with it.
>
> This is
>
>         if (expr1 &&
>                 expr2)
>
> versus
>
>         if (expr1
>                 && expr2)
>
> the former is more common and is, IMO, more readable.

Existing kernel code is all over the place w.r.t. this one. Even a same
person doesn't follow a single convention all the time (see kernel/signal.c
for all sorts of compound-conditions-indentation-abuse :-)

> The latter can be handy sometimes to prevent an 80-col overflow in the
> first line.

Actually, the latter style (one condition per line and the && or ||
operators appearing _before_ the conditions in subsequent lines)
is quite popular for multi-line compound conditions (well, I've seen this
in kernel/workqueue.c, kernel/stop_machine.c, etc at least, and also in
Linus' code, if I'm not mistaken). We also align subsequent lines to the
column of the condition belonging to the same "logical level" on the
previous line using _spaces_ (note that this is alignment, not indentation,
using spaces). The rationale is to make the operator prominent and thus make
the structure of a complex multi-line compound conditional expression more
readable and obvious at first glance itself. For example, consider:

	if (veryverylengthycondition1 &&
		smallcond2 &&
		(conditionnumber3a ||
		condition3b)) {
		...
	}

versus

	if (veryverylengthycondition1
	    && smallcond2
	    && (conditionnumber3a
	        || condition3b)) {
		...
	}

?

Latter wins, doesn't it?

Satyam
