Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZIWI0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZIWI0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZIWI0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:26:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:49566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754504AbZIWI0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:26:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+JNzRCCQCJR/f/OgHTxkGDuIa9XdofqpmL1raLN+
	jurAeOa2o5U+5i
Subject: Re: mailing list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
In-Reply-To: <4AB9221A.8010507@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <1253620488.13917.29.camel@marge.simson.net>
	 <1253627604.7272.17.camel@marge.simson.net>  <4AB8D930.1090308@redhat.com>
	 <1253646556.7240.4.camel@marge.simson.net>  <4AB9221A.8010507@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 10:26:40 +0200
Message-Id: <1253694400.8155.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 22:14 +0300, Avi Kivity wrote:
> On 09/22/2009 10:09 PM, Mike Galbraith wrote:
> > On Tue, 2009-09-22 at 17:03 +0300, Avi Kivity wrote:
> >    
> >> On 09/22/2009 04:53 PM, Mike Galbraith wrote:
> >>      
> >>> Parses fine here, and INSTALL_MOD_STRIP=1 made zero difference.  can you
> >>> send me that module and .config gzipped up?
> >>>
> >>>
> >>>        
> >> Sent privately.
> >>      
> > I can reproduce with your config, so do don't (thankfully) need to rip
> > binary apart looking for tools things.  Will take a look.
> >    
> 
> Thanks!  While trace/perf still have some rough edges, they've already 
> proven incredibly valuable for debugging and performance analysis.

Heh, fixed that... pass the baggies please ;-)

With your config, symbols were being loaded twice.  Parsing of vmlinux
and modules goes fine.  Unless there are no modules currently loaded, or
_the last module scanned isn't loaded_ that is.  dso__load_modules()
then returns 0, and we fall back to kallsyms.. making a mess.

Anyway, there's some other bustage with your config, so I'm going to
have to do more symbol table debugging/validation.

	-Mike

