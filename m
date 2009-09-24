Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbZIXVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbZIXVge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZIXVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:36:34 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:43263 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIXVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HrR0qIA/y+BNWr72S+90hct6821TSkAiH36WsVUt2OMdVP07QZPqzT0yYrzd4xm1vk
         KQDtvtvvEDysE17pGabQhzH8z/ELYt8uOLqRthHFVPDWfHv4bVB+/WLHuNUiZ0QOghrH
         YwDNkT27lQUXBWmL1POI0Cao5AczjAbwPbHlA=
Date: Thu, 24 Sep 2009 23:36:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090924213631.GA2661@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere> <1253825489.18939.180.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253825489.18939.180.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:51:29PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 22:44 +0200, Frederic Weisbecker wrote:
> 
> > I don't quite understand why.
> > 
> > Typing file == "*reiserfs*" looks more intuitive.
> > 
> > It's true that the filters should stay tight to the C syntax,
> > but following this guideline up to the point that we are forced to
> > use function expressions to do something that can be expressed
> > much more easily and more intuitively (IMHO), that all sounds like
> > an overkill.
> > 
> > The use of glob is a very primary need for filters, it's
> > so much a basic requirement for it that it should be native
> > in its language.
> 
> The thing that my fingers know is awk syntax:
> 
>  file ~ /reiserfs/
> 
> I'd very much prefer to keep == for strict equality, however the above
> requires actual regex bits.


The strict equality issue was the reason that made me first
split the filter file into "filter" and "filter_regex", that
actually should have been "filter_glob" :-)

But the general opinion was in favour of a single file
supporting these globs, especially since it's a non-abi thing.

In the current state, in its current scope and use, I think these
native globs are the right choice.

But if we start to consider it in a larger scope, used by perf and
may be for even wider uses than trace events, then yes we should
double-check the impact of this syntax change.
 

> Remember, there are no second chances for the filter syntax anymore.


But well, it's not yet an ABI. It's still a baby, although powerful
for filtering, it's not yet a whole scripting language.

Before thinking about it as an ABI, we should develop it, extend
it, use these extensions, spot the weaknesses in the syntax, fix them,
etc...

