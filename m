Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbZJWBK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbZJWBK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZJWBK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:10:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41335 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZJWBK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:10:27 -0400
Subject: Re: [RFC] tracefs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Greg KH <greg@kroah.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091023004937.GA24035@kroah.com>
References: <20091023004937.GA24035@kroah.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 22 Oct 2009 21:10:30 -0400
Message-Id: <1256260230.20866.816.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 17:49 -0700, Greg KH wrote:
> Hi all,
> 
> At LinuxCon this year, Steven and I talked about moving the debugfs
> usage in the tracing core to a stand-alone filesystem to give the
> ability to start to lock down the api so that people an count on what is
> going on in the tracing userspace interface.
> 
> So, on the flight to Tokyo for the kernel summit, I wrote up tracefs.
> Here's the first very rough cut at it below.  I've run it here on my
> laptop, and all seems well, but I do have a few questions:
>   - I've made the mount point be /sys/kernel/trace/  Is that ok?  Should
>     it be /sys/kernel/tracing/?  Or something else?  You get to pick the
>     mount point now, so I don't want to hear any more grumblings about
>     the location in the future :)

/trace

 (rostedt hides)


>   - the block tracing code was not changed, as it uses
>     /sys/kernel/debug/block/ at the moment, not the
>     /sys/kernel/debug/tracing/ directory.  To change the block tracing
>     code, it would require us to change the userspace tools as well,
>     which I don't know if we want to do.  Thanks to Jens for
>     straightening this all out for me, originally I thought it was a bug
>     in the block tracing code.

I thought we were suppose to port the block tracing over to tracepoints
anyway, and remove the "block" tracer?

>   - is this type of conversion to a custom virtual filesystem acceptable
>     to the other tracing developers?  Any objection to not using debugfs
>     calls anymore?  The operation is identical, but it keeps the rest of
>     the kernel from intruding on your space now.

What I would like is to still use debugfs for new features until we
understand them better. That location, files can disappear or have their
formats completely changed. When things move to tracefs, then the API is
a bit more rigid. Files can still change, but they must change in a way
to be backward compatible. We need a nice way to document how a file can
change, and stick to it.

> 
> Again, this is a very rough cut, I know I can make this smaller, and
> actually make the code in the tracing core a bit simpler when calling
> tracefs, as it does not need to support all the different options that
> debugfs did.
> 
> Also, the init path for tracefs needs to be reworked, as it's a bit too
> complex now.  This will reduce the usage of the "is this initialized"
> type mess that the patch below currently has.
> 
> Oh, and yes, I will split this up properly as well for a real
> submission :)
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
> Subject: tracefs
> 
> This replaces the debugfs usage in the tracing core with a custom
> virtual filesystem for its use only.
> 
> Not-Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

[ Snip the s/debugfs/tracefs/ changes ]

Note, as mentioned above. I envision having a way to start out in
debugfs and then slowly move things over to tracefs when they become
standardize. Think of debugfs as linux-next ;-)

Although most of the files are pretty much stable, I don't want to do a
cross the board change at the moment.

> diff --git a/kernel/trace/tracefs.c b/kernel/trace/tracefs.c
> new file mode 100644
> index 0000000..8ac9394
> --- /dev/null
> +++ b/kernel/trace/tracefs.c

[ Snip the rest because I just know it is perfect ;-) ]


Thanks Greg!

-- Steve


