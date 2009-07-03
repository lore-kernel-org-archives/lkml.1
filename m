Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZGCQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZGCQaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZGCQaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:30:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:64733 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZGCQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lh6N5FxxM2G1M6utJBx3U/d0QL1SZLcyELjp3Q7yaDfgbhEmAojHFSw2nIRr3gzTDY
         KjD64eMHfQ99EosOAc61q3Fn37rT6qWsQQV0mwDMZOE+gl5UE0t48fE8il7Cg2gdlmuF
         uFRjSqqcifiE4XoaiclFBpwXEfE0rk9jC/+vM=
Date: Fri, 3 Jul 2009 11:30:11 -0500
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: Infrastructure for tracking driver performance events
Message-ID: <20090703163011.GA7476@ben-laptop>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org
References: <20090624172912.GB5565@ben-laptop>
 <alpine.DEB.2.00.0906241549170.15398@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906241549170.15398@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 08:55:51AM -0400, Steven Rostedt wrote:
> 
> 
> On Wed, 24 Jun 2009, Ben Gamari wrote:
> You can filter on functions to trace. Or add a list of functions
> in set_graph_function to just graph a specific list.

Perfect.

> 
> > 2) It is difficult to extract the kernel mode callgraph with no natural
> >    way to capture the usermode callgraph
> 
> Do you just need a backtrace of some point, or a full user mode graph?

Just a backtrace to the syscall invocation. This should allow us to
identify which path mesa or the ddx took to hit the slow path.

> 
> > 3) A large amount of usermode support is necessary (which will likely be
> >    the case for any option; listed here for completeness)
> > 
> > Another option seems to be systemtap. It has already been documented[3]
> > that this option could provide both user-mode and kernel-mode
> > backtraces. The driver could provide a kernel marker at every potential
> > wait point (or a single marker in a function called at each wait point,
> > for that matter) which would be picked up by systemtap and processed in
> > usermode, calling ptrace to acquire a usermode backtrace. This approach
> > seems slightly cleaner as it doesn't require the tracing on the entire
> > machine to catch what should be reasonably rare events (hopefully).
> 
> Enabling the userstacktrace will give userspace stack traces at event
> trace points. The thing is that the userspace utility must be built with 
> frame pointers.

Yep, I apparently hadn't read through the documentation all that well.
It looks like the stacktrace and userstacktrace will serve quite nicely.
Are there preexisting tools for resolving addresses in the produced
stacktrace into symbols? Is there an example of this being done
somewhere? Thanks,

- Ben

