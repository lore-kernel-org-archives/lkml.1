Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0BYBh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:37:26 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51161 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab0BYBhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pCfMDbiHiwNhK15zhnSibhDdNEqSDSkCufPKeJdYDi0WszYqR9+qpfOfk2g230YSrZ
         e9g4HBOXTCy7VLqshWbUsj82pn3SKk0kI34jLCOuqqY5I860YnsIcjQAp5UhsOpSYarU
         4+mGWNwhfbj+amu9omtfsvJlr5kfE7Gog+YmA=
Date: Thu, 25 Feb 2010 02:37:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 12/12] perf trace/scripting: add perf-trace-python
	Documentation
Message-ID: <20100225013720.GB7491@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-13-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264580883-15324-13-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:28:03AM -0600, Tom Zanussi wrote:
> +from perf_trace_context import *
> +from Core import *
> +
> +def trace_end():
> +	print "in trace_end"
> +
> +def raw_syscalls__sys_enter(event_name, context, common_cpu,
> +	common_secs, common_nsecs, common_pid, common_comm,
> +	id, args):
> +----
> +
> +In trace_end(), we'll simply print the results, but first we need to
> +generate some results to print.  To do that we need to have our
> +sys_enter() handler do the necessary tallying until all events have
> +been counted.  A hash table indexed by syscall id is a good way to
> +store that information; every time the sys_enter() handler is called,
> +we simply increment a count associated with that hash entry indexed by
> +that syscall id:
> +
> +----
> +  syscalls = autodict()
> +
> +  try:
> +    syscalls[id] += 1
> +  except TypeError:
> +    syscalls[id] = 1
> +----
> +
> +The syscalls 'autodict' object is a special kind of Python dictionary
> +(implemented in Core.py) that implements Perl's 'autovivifying' hashes
> +in Python i.e. with autovivifying hashes, you can assign nested hash
> +values without having to go to the trouble of creating intermediate
> +levels if they don't exist e.g syscalls[comm][pid][id] = 1 will create
> +the intermediate hash levels and finally assign the value 1 to the
> +hash entry for 'id' (because the value being assigned isn't a hash
> +object itself, the initial value is assigned in the TypeError
> +exception.  Well, there may be a better way to do this in Python but
> +that's what works for now).


That's smart. I wish python had a native type for that.

And looking how you made it easily....

def autodict():
    return defaultdict(autodict)

