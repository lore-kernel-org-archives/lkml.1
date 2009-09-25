Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZIYJMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZIYJMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZIYJMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:12:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36631 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZIYJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zrk28VYnMLCE8579KjB3P5BVgNWygyd4PaiCNBpmeVuUK7CqD4duS3Vd2VUrfPXj0u
         9IwgiGpVFWdhJD5lRybuSFdjR4HnQ3OBtDKuIRScKUE9uytL2Yg8wB9zpr3tamSLKmnj
         PVlYys44mxDK6I+UJi4q3AdD25Egt7JPxdoE4=
Date: Fri, 25 Sep 2009 11:12:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090925091229.GB4686@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere> <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere> <1253866792.10287.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253866792.10287.0.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 10:19:52AM +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 23:36 +0200, Frederic Weisbecker wrote:
> 
> > > Remember, there are no second chances for the filter syntax anymore.
> > 
> > 
> > But well, it's not yet an ABI. It's still a baby, although powerful
> > for filtering, it's not yet a whole scripting language.
> > 
> > Before thinking about it as an ABI, we should develop it, extend
> > it, use these extensions, spot the weaknesses in the syntax, fix them,
> > etc...
> 
> Then this is a NACK for the perf ioctl for setting a filter. Fine with
> me.


Ftrace side (debugfs use):

I think the native filter glob is good for ftrace use through debugfs.
As I said, IMO it's so much a primary requirement for events filtering
that it should be a default.
But if others have mixed feelings about it, tell me and I will
reconsider. I've done this native glob in this patchset because the
general opinion (yours included) was in favour of that, instead of
a split into a filter and another filter_glob file.
That said, the future plans have evolved, and I'm fine if you have
changed your opinion and think about a better way to develop this.


Perf side:

But the use from perf would be for a larger scope. And I agree we may
want to break this glob default from it to get a flexible usability
and use a pure string match by default that we can override with
functions-like expressions.


So why not keeping the default native blob for ftrace and throw away
this default for perf? It's a matter of a flag in the filters.

You don't need to drop a NACK rock on the ground and laconically go out
like that to wake me up. I think I've already enough shown how much I'm
willing to help building a nice bridge between ftrace and perf.
I just don't want that this bridge turns out any ftrace uses through debugfs
into an overkill.
Instead I'd prefer to satisfy both, hence the above proposition.

Thanks,
Frederic.

