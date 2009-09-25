Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZIYKiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZIYKiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIYKiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:38:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:21884 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZIYKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u2YtgYMsw73tnwsfv0M7DdJ+140mJprNg3vcoDayiW6cBXgLk5dSoR/Hd7g+im0XBv
         JKAzbYmn2z+HzeBe9M/QaPco49cLjfImx2tDQZcqxdFIG5rAAvNLmNWNOYVDI8j6JNvd
         Bb2XOXTTdk6bZ/q1I+eR7sAnpEnPvSo8y6Cqg=
Date: Fri, 25 Sep 2009 12:38:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090925103806.GA6467@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere> <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere> <1253866792.10287.0.camel@twins> <20090925091229.GB4686@nowhere> <1253871601.10287.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253871601.10287.23.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:40:00AM +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-25 at 11:12 +0200, Frederic Weisbecker wrote:
> > That said, the future plans have evolved, and I'm fine if you have
> > changed your opinion and think about a better way to develop this.
> 
> No, but the thing is, IF we're going to freeze this into ABI, then
> there's no second chances.



Right. Once it becomes an ioctl, it becomes an ABI :-/


 
> Using globs in string matches most certainly is useful, no question
> about that.
> 
> But I had understood from previous communications we were going to have
> a C syntax, and there == is a straight comparison.
> 
> If however people have changed their minds (fine with me) and we're now
> going to script like things..



Well, indeed we talked about C syntax, but I didn't think the idea
was that fixed in the rock, hence why I was suprised.


> Anyway, a glob in == just means we have to use another operator if we
> ever want to support actual regexes, ~ would then be recommened I think,
> since that's what awk and I think perl do.


Yeah. For example one may know python but not perl or awk,
other people may be in the opposite situation. But most
developers know the C (at least its basic syntax).

So I'm not sure using such ~ operator is a good idea. I think you're
right in the fact we should stay tight to the C syntax.


> Personally I wouldn't mind things like:
> 
>  glob_match(string, pattern)
>  regex_match(string, pattern)



Yeah, actually that sounds more flexible and more something that people
are familar with, once we consider the future evolutions.



> But everybody involved in this filter stuff needs to agree what
> direction you want to take the language in.



Right!

 

> > I just don't want that this bridge turns out any ftrace uses through debugfs
> > into an overkill.
> > Instead I'd prefer to satisfy both, hence the above proposition.
> 
> So you're proposing to split the filter language? I'm sure that's going
> to confuse a few people ;-)



Hmm, just at this level. That could even be a trace option.
Anyway, it would nice to have other tracing developers
opinion.


 
> Thing is, if you (or others) have a need to experiment with the
> language, then I'm not sure its the right moment to freeze bits into an
> ABI.
> 
> I'm really fine with thing, as long as everybody on the filter side
> knows experimenting isn't really an option and agrees on the direction
> they want to take the language.


Well, I talked about experimenting the language before pushing it as
an ABI because I was afraid we were going too fast.

But I guess the ABI is a requirement to use it through perf ioctl,
and delay that would keep it as a hostage, may be even slow its
development.


> Is there no existing language with a proper license and clean code-base
> we can 'borrow'? That would avoid creating yet another funny language,
> and learning how to implement things all over again.
> 
> Personally I don't think the kernel is the place to experiment in script
> language design, but that's me ;-)


Python? :-)

More seriously, as I said above, I think most developers are familiar with C
syntax, so IMHO this is one of our best possibility.

