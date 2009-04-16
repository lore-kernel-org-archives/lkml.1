Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZDPQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZDPQFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZDPQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:05:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64339 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbZDPQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRkJvosz151yk0QM3fjPy4EFMOgdgs0rbSD9aFHNy/+z3afmlaGIlTNKktp+dQZpPh
         Bu3gfTL2m0MxL1InA39/RluXs6QyPatYaCOAeUwCZiRjrl6CVYvbF5PJs0zAhdaYes/a
         /0EoN1OrrbufYpEbpHKI7tiyxNuOtqLR0TIm4=
Date: Thu, 16 Apr 2009 18:05:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Avadh Patel <avadh4all@gmail.com>
Subject: Re: [PATCH 5/5] tracing: add saved_cmdlines file to show cached
	task comms
Message-ID: <20090416160538.GF6004@nowhere>
References: <20090416021830.556671772@goodmis.org> <20090416021928.956953374@goodmis.org> <20090416155444.GD6004@nowhere> <alpine.DEB.2.00.0904161156070.20429@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904161156070.20429@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 11:58:44AM -0400, Steven Rostedt wrote:
> 
> On Thu, 16 Apr 2009, Frederic Weisbecker wrote:
> 
> > On Wed, Apr 15, 2009 at 10:18:35PM -0400, Steven Rostedt wrote:
> > > From: Avadh Patel <avadh4all@gmail.com>
> > > 
> > > Export the cached task comms to userspace. This allows user apps to translate
> > > the pids from a trace into their respective task command lines.
> > 
> > 
> > Hi,
> > 
> > I don't understand why this is needed. The pid is already resolved
> > to its task comm into the trace.
> 
> Nope, it is not. The trace buffer does not hold the comm. It is in an 
> internal cache within ftrace. This exports this table.


Ah ok, it's about the ring buffer direct fetching. I've only thought
about ftrace.


 
> > 
> > Or is there another reason?
> 
> If you were to perform a trace, and then stop it. Only the pids are in the 
> trace buffer. If those processes end, there's no way to find out what 
> process were attached to those pids. This table maps the pids in the 
> buffer to the comms saved in the cache. As long as you don't run another 
> trace, the cache will hold the pids in the trace.


Ok.


> 
> Note, this is for reading the binary data files.


And I missed that too.
Thanks for the explanations!


> -- Steve
> 

