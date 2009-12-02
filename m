Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZLBXUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZLBXUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZLBXU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:20:29 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:55201 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbZLBXU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:20:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAIp/FktGGNlG/2dsb2JhbACBTtY6hDEE
Date: Wed, 2 Dec 2009 18:15:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
Message-ID: <20091202231529.GC14770@Krystal>
References: <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com> <20091202190135.GA23316@Krystal> <1259781578.12870.78.camel@gandalf.stny.rr.com> <4B16EC06.6010706@redhat.com> <1259794005.12870.102.camel@gandalf.stny.rr.com> <20091202225736.GA14770@Krystal> <4B16F389.4090801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B16F389.4090801@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:12:03 up 14:02,  3 users,  load average: 0.76, 0.83, 0.81
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 12/02/2009 02:57 PM, Mathieu Desnoyers wrote:
> >>
> >> TRACE_CLASS - Declares a class
> >> TRACE_CLASS_EVENT - defines an event for said class
> >> TRACE_EVENT - Declares a class and defines an event (as is today)
> > 
> > Yep, it looks good! It's self-descriptive and don't require to explain
> > what the thing is doing each time we refer to it. (however I feel a bit
> > sad for Fred, Wilma and Barney) ;)
> > 
> 
> Although you have to admit it's a bit confusing that:
> 
> TRACE_EVENT = TRACE_CLASS + TRACE_CLASS_EVENT
> 
> ... as opposed to ...
> 
> TRACE_CLASS_EVENT = TRACE_CLASS + TRACE_EVENT
> 
> 	-hpa

Then I would say that TRACE_EVENT should probably not have the
side-effect of declaring a globally-reuseable class. Maybe under the
hood it could create a privately-named class, but I don't see how it can
be re-used by following TRACE_CLASS_EVENT without causing confusion.

I'd go for:

TRACE_CLASS - Declares/defines a class
TRACE_CLASS_EVENT - Declares/defines an event for said class
TRACE_EVENT - Declares/defines a private class and declares/defines an event

Mathieu



> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
