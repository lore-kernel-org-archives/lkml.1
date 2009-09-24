Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZIXUoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZIXUoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZIXUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:44:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42667 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZIXUoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XdsMB1D6hKSJVyRkgnCexpfPi6bBN1jkHjl7sbC0cw+h+L0TX7G3m8FoUAcBuRmya2
         8Ubs3NYa0ouJuHchKMsa2oX1Mvwf5F8gMT87E/YVMmLWyYQ8xsvNdlOd3QkqOgjODNeq
         JXxQl92hTtdSthWM3HiR7IQIkJ+rPJ9mjzCpA=
Date: Thu, 24 Sep 2009 22:44:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090924204357.GB8662@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253824200.18939.173.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:30:00PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 22:16 +0200, Ingo Molnar wrote:
> 
> > There's one thing Peter noticed: this is not C syntax anymore. It would 
> > be really nice to keep filter expressions a subset of C.
> 
> Also:
> 
> > This patch provides basic support for regular expressions in filters.
> > 
> > It supports the following types of regexp:
> > 
> > - *match_beginning
> > - *match_middle*
> > - match_end*
> > - !don't match
> > 
> > Example:
> >         cd /debug/tracing/events/bkl/lock_kernel
> >         echo 'file == "*reiserfs*"' > filter
> >         echo 1 > enable
> 
> It says regex, but its not.
> 
> Regex would look like: "^.*reiserfs.*$", or simply "reiserfs"
> 
> What you implemented is called glob-matching.


Ouch, right...

 
> If you want to keep this C syntax, you could consider something like:
> 
>  glob_match(file, "*reiserfs*")
> 
> or something.
> 


I don't quite understand why.

Typing file == "*reiserfs*" looks more intuitive.

It's true that the filters should stay tight to the C syntax,
but following this guideline up to the point that we are forced to
use function expressions to do something that can be expressed
much more easily and more intuitively (IMHO), that all sounds like
an overkill.

The use of glob is a very primary need for filters, it's
so much a basic requirement for it that it should be native
in its language.

