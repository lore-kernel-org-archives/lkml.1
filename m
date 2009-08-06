Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZHFPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZHFPCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZHFPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:02:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZHFPCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:02:22 -0400
Date: Thu, 6 Aug 2009 11:02:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace scripts and make V=1
In-Reply-To: <20090806034325.GA8861@elte.hu>
Message-ID: <alpine.DEB.2.00.0908061100580.22376@gandalf.stny.rr.com>
References: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com> <20090805072952.GC19322@elte.hu> <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com> <20090806034325.GA8861@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Ingo Molnar wrote:
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index d29baa2..4889c44 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -414,7 +414,10 @@ while (<IN>) {
> >  	    $offset = hex $1;
> >  	} else {
> >  	    # if we already have a function, and this is weak, skip it
> > -	    if (!defined($ref_func) && !defined($weak{$text})) {
> > +	    if (!defined($ref_func) && !defined($weak{$text}) &&
> > +		 # PPC64 can have symbols that start with .L and
> > +		 # gcc considers these special. Don't use them!
> > +		 $text !~ /^\.L/) {
> >  		$ref_func = $text;
> >  		$offset = hex $1;
> >  	    }
> 
> Ah, indeed. I'm wondering whether also emitting a build warning 
> would be useful - just in the (admittedly unlikely) case of someone 
> wondering about why LM93_IN_FROM_REG does not show up in function 
> traces.

Actually, it just skips it as the function to use as the reference point. 
It should still record the mcount for that function. Now we may have an 
issues if all functions in a section start with .L

-- Steve

