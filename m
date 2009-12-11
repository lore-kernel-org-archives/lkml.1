Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZLKUwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZLKUwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZLKUwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:52:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZLKUwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:52:01 -0500
Date: Fri, 11 Dec 2009 18:51:41 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
Message-ID: <20091211205141.GA1949@ghostprotocols.net>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
 <20091209072220.GA4328@elte.hu>
 <20091209084341.GA21333@elte.hu>
 <4B1FE022.1030704@redhat.com>
 <4B201993.9020005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B201993.9020005@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 09, 2009 at 04:41:39PM -0500, Masami Hiramatsu escreveu:
> Masami Hiramatsu wrote:
> >> Here the failure was because the symbol does not exist.
> > 
> > Yeah, so that's what I'm expecting to be implemented with below item :-)
> > 
> >    - Symbol search by libelf/kallsyms
> > 
> > I guess it will be done by using symbol.c.
> > (Actually, current
> 
> Oops, I might miss something, forgot it.
> actually, current perf probe doesn't decode kallsyms/elf, it just depends on
> kprobe-tracer. And kprobe-tracer will return -EINVAL not only if the symbol
> was not found, but also other reasons.
> 
> So, if we want to show below message, we need to decode elf or kallsyms.

Should be easy now with my latest patch :-)
 
> > >
> > > There's similar problems in most other failure cases. Trying to remove a
> > > non-existent probe gives:
> > >
> > >   # perf probe -d test
> > >   Warning: event "probe:test" is not found.
