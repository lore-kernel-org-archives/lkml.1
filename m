Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZILUY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZILUY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZILUYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:24:25 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54291 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZILUYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lv9Ns3MyQjFevoL7X82tWfRFDu1QhHKzbybWHIKia9c/RcO3gK4KyyVRUqHgbU8s+V
         tBdfsI7S0FUWMmNCK2visduo4lKmPlLwoAlZAsloCikEZCUQqaMVtOLBOwfpIT7PDTIE
         0+pu7vzJLReP0Ka48zxFN/72IIHyeHrpx6GSY=
Date: Sat, 12 Sep 2009 22:24:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event
	macro
Message-ID: <20090912202422.GF4961@nowhere>
References: <1238478556.6749.14.camel@bookworm> <1252785412.18996.760.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252785412.18996.760.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 03:56:52PM -0400, Steven Rostedt wrote:
> On Tue, 2009-03-31 at 00:49 -0500, Tom Zanussi wrote:
> > Frederic Weisbecker suggested that the trace_special event shouldn't be
> > filterable; this patch adds a TRACE_EVENT_FORMAT_NOFILTER event macro
> > that allows an event format to be exported without having a filter
> > attached, and removes filtering from the trace_special event.
> > 
> 
> Frederic,
> 
> Do you remember why trace_special should not be filtered? I think
> earlier we use to use it for lots of special markings, but now that we
> have trace_printk, at least I have not used it in a long time.
> 
> Reason why I'm asking, is that I've wrote a patch that automates the
> format of the debugfs/tracing/events/ftrace/* files. I'm using macros
> like we have in include/trace/events/ to create the ftrace internal
> structures. This way we get rid of the manual exporting of that
> directory and now the formats will be automatically match the ring
> buffer internals.
> 
> This also adds some entries that were not ported, just because it is
> automated we get all of them. I'm thinking it would be more powerful to
> let all ftrace entries be filtered. Even the trace_printks.
> 
> What do you think?
> 
> -- Steve



It's not that it would harm but it would be meaningless.
The tracer that uses the special entry is the only one
that can give sense to it.

Sysprof is the only user IIRC.

If I'm not wrong, the first field gives the sense of the other fields:

0 -> pid
1 -> backtrace node
2 -> backtrace node (userland)
3 -> backtrace overflow

Well, actually while thinking more about it, we may want to
filter with "arg0 == 1 && arg1 == addr_to_filter_in_a_callchain" or things like
that.

So I guess actually that could be useful.
I did not think about it at that time...

