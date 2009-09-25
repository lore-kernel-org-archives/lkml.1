Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZIYHzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZIYHzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZIYHza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:55:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:56793 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZIYHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UTMaonQpZfuKIecPZDV1kZrxhbRgGQbrxQxSqlUsGoF1Yc/jjgd7dygpYdljRPoMyF
         +yEgl7t8w9FS8JVk8JDhdQ5eqPAiLjV43qIonldDfsWwjDNQbXstT409AqSr8REvEYQq
         T/U5AH1ybsHMpvAOylu4mB/Ln8FHb0DtuN1EQ=
Date: Fri, 25 Sep 2009 09:55:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090925075528.GC4700@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu> <20090924202225.GA15108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924202225.GA15108@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:22:25PM +0200, Ingo Molnar wrote:
> 
> also, some build problems:
> 
> include/trace/events/bkl.h: In function 
> ?ftrace_profile_enable_lock_kernel?:
> include/trace/events/bkl.h:9: error: implicit declaration of function 
> ?register_trace_lock_kernel?
> include/trace/events/bkl.h: In function 
> ?ftrace_profile_disable_lock_kernel?:
> include/trace/events/bkl.h:9: error: implicit declaration of function 
> ?unregister_trace_lock_kernel?
> include/trace/events/bkl.h: In function 
> ?ftrace_profile_enable_unlock_kernel?:
> include/trace/events/bkl.h:34: error: implicit declaration of function 
> ?register_trace_unlock_kernel?
> include/trace/events/bkl.h: In function 
> ?ftrace_profile_disable_unlock_kernel?:
> include/trace/events/bkl.h:34: error: implicit declaration of function 
> ?unregister_trace_unlock_kernel?
> 
> config attached.
> 
> 	Ingo


Ok, I see. The problem is that include/ftrace_event.h includes hardirq.h
which includes smp_lock.h, then each time we define another tracepoint, we
redefine the bkl tracepoints.

Thanks, I'll fix this.

