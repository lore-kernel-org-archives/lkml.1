Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZLIVmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZLIVmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZLIVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZLIVl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:41:58 -0500
Message-ID: <4B201993.9020005@redhat.com>
Date: Wed, 09 Dec 2009 16:41:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com> <20091209072220.GA4328@elte.hu> <20091209084341.GA21333@elte.hu> <4B1FE022.1030704@redhat.com>
In-Reply-To: <4B1FE022.1030704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>> Here the failure was because the symbol does not exist.
> 
> Yeah, so that's what I'm expecting to be implemented with below item :-)
> 
>    - Symbol search by libelf/kallsyms
> 
> I guess it will be done by using symbol.c.
> (Actually, current

Oops, I might miss something, forgot it.
actually, current perf probe doesn't decode kallsyms/elf, it just depends on
kprobe-tracer. And kprobe-tracer will return -EINVAL not only if the symbol
was not found, but also other reasons.

So, if we want to show below message, we need to decode elf or kallsyms.

> >
> > There's similar problems in most other failure cases. Trying to remove a
> > non-existent probe gives:
> >
> >   # perf probe -d test
> >   Warning: event "probe:test" is not found.
> >

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

