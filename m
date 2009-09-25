Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZIYJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZIYJjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZIYJjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:39:21 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:27891 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZIYJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:39:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20090925091229.GB4686@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	 <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere>
	 <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere>
	 <1253866792.10287.0.camel@twins>  <20090925091229.GB4686@nowhere>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 11:40:00 +0200
Message-Id: <1253871601.10287.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 11:12 +0200, Frederic Weisbecker wrote:
> On Fri, Sep 25, 2009 at 10:19:52AM +0200, Peter Zijlstra wrote:
> > On Thu, 2009-09-24 at 23:36 +0200, Frederic Weisbecker wrote:
> > 
> > > > Remember, there are no second chances for the filter syntax anymore.
> > > 
> > > 
> > > But well, it's not yet an ABI. It's still a baby, although powerful
> > > for filtering, it's not yet a whole scripting language.
> > > 
> > > Before thinking about it as an ABI, we should develop it, extend
> > > it, use these extensions, spot the weaknesses in the syntax, fix them,
> > > etc...
> > 
> > Then this is a NACK for the perf ioctl for setting a filter. Fine with
> > me.
> 
> 
> Ftrace side (debugfs use):
> 
> I think the native filter glob is good for ftrace use through debugfs.
> As I said, IMO it's so much a primary requirement for events filtering
> that it should be a default.
> But if others have mixed feelings about it, tell me and I will
> reconsider. I've done this native glob in this patchset because the
> general opinion (yours included) was in favour of that, instead of
> a split into a filter and another filter_glob file.

Agreed, a single filter syntax is much preferred.

> That said, the future plans have evolved, and I'm fine if you have
> changed your opinion and think about a better way to develop this.

No, but the thing is, IF we're going to freeze this into ABI, then
there's no second chances.

Using globs in string matches most certainly is useful, no question
about that.

But I had understood from previous communications we were going to have
a C syntax, and there == is a straight comparison.

If however people have changed their minds (fine with me) and we're now
going to script like things..

Anyway, a glob in == just means we have to use another operator if we
ever want to support actual regexes, ~ would then be recommened I think,
since that's what awk and I think perl do.

Personally I wouldn't mind things like:

 glob_match(string, pattern)
 regex_match(string, pattern)

But everybody involved in this filter stuff needs to agree what
direction you want to take the language in.

> Perf side:
> 
> But the use from perf would be for a larger scope. And I agree we may
> want to break this glob default from it to get a flexible usability
> and use a pure string match by default that we can override with
> functions-like expressions.
> 
> 
> So why not keeping the default native blob for ftrace and throw away
> this default for perf? It's a matter of a flag in the filters.
> 
> You don't need to drop a NACK rock on the ground and laconically go out
> like that to wake me up. I think I've already enough shown how much I'm
> willing to help building a nice bridge between ftrace and perf.

Sure, and thanks for that, your efforts really are appreciated.

> I just don't want that this bridge turns out any ftrace uses through debugfs
> into an overkill.
> Instead I'd prefer to satisfy both, hence the above proposition.

So you're proposing to split the filter language? I'm sure that's going
to confuse a few people ;-)

Thing is, if you (or others) have a need to experiment with the
language, then I'm not sure its the right moment to freeze bits into an
ABI.

I'm really fine with thing, as long as everybody on the filter side
knows experimenting isn't really an option and agrees on the direction
they want to take the language.

Is there no existing language with a proper license and clean code-base
we can 'borrow'? That would avoid creating yet another funny language,
and learning how to implement things all over again.

Personally I don't think the kernel is the place to experiment in script
language design, but that's me ;-)

