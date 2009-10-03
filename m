Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZJCLtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZJCLtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 07:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZJCLtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 07:49:51 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:43549 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZJCLtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 07:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OUy1fjwn4+TBwIgqwUMlFm3RrzWKqPBGNO/3GpgYb/KI7FE9nxX994tM491/KQCqqN
         FR8KxYGiB5rtkYQsHArFU6L6PqL3vzBuahiPfw7tfP5VDpTzY2//QKAhNBEEahcwRSJz
         feQ3zbNkxiXDPZt9v2HAwroSD1/JHb6Q9eAQ8=
Date: Sat, 3 Oct 2009 13:49:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20091003114950.GB6366@nowhere>
References: <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere> <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere> <1253866792.10287.0.camel@twins> <20090925091229.GB4686@nowhere> <1253871601.10287.23.camel@twins> <20090925103806.GA6467@nowhere> <y0mljk1lnd1.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mljk1lnd1.fsf@fche.csb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:47:06AM -0400, Frank Ch. Eigler wrote:
> 
> Hi -
> 
> 
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> >> > That said, the future plans have evolved, and I'm fine if you have
> >> > changed your opinion and think about a better way to develop this.
> 
> >> No, but the thing is, IF we're going to freeze this into ABI, then
> >> there's no second chances.
> 
> > Right. Once it becomes an ioctl, it becomes an ABI :-/
> 
> Are y'all convinced that a little ascii language parser/interpreter is
> the right thing to put into the kernel, as opposed to bytecode (with a
> userspace compiler)?
> 
> - FChE


We need something directly understandable from the kernel interfaces.
As an example we don't want the ftrace users to bother about compiling
a string before applying it on an event filter through ftrace debugfs
interface, we want it directly usable without middle-state in the worklow.

That's also the same for perf syscalls users.

Moreover it's a really small language, based on predicates. Fetching
strings against bytecodes won't make that much differences in the
amount of kernel code to maintain.

