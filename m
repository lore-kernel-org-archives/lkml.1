Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZDFHzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZDFHzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZDFHy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:54:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZDFHyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:54:55 -0400
Message-ID: <49D9B504.2050901@redhat.com>
Date: Mon, 06 Apr 2009 10:53:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: Masami Hiramatsu <mhiramat@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com>	<20090403112639.GC31399@elte.hu>	<49D5F80B.7000305@redhat.com>	<20090403121202.GI31399@elte.hu>	<49D5FE42.5080100@redhat.com>	<20090403122654.GA19451@elte.hu>	<19f34abd0904030616v56d66a11u7ee6054502f2922@mail.gmail.com>	<49D61489.9020406@redhat.com> <20090405223710.49299b9a@daedalus.pq.iki.fi>
In-Reply-To: <20090405223710.49299b9a@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> Not just emulation but address diversion, i.e. modifying the operation
> (not the text) before executing it. Mmiotrace could do something like
> this:
> 1. a blob calls ioremap
> 2. mmiotrace maps the MMIO area privately
> 3. the blob receives a dummy map from ioremap, that will generate
> page fault
> 4. the blob accesses the dummy map and raises a page fault
> 5. pf handler detects the dummy map
> 6. mmiotrace pf handler emulates the instruction and replaces the
> dummy address with the real MMIO address.
> 7. mmiotrace records the operation and the datum
> 8. go to step 4, or whatever
>
> This means mmiotrace would not have to fiddle with the page
> tables and page presence bits like it does now. As said, this
> would make mmiotrace SMP-proof, and also eliminate the die notifier
> (used for the instruction single stepping trap).
>
> IMO a big step from a hack to a tool. Getting rid of the custom
> instruction parser in mmiotrace would be a good step in itself.
>
> Avi Kivity noted, that the KVM emulator does almost everything. Does
> it allow also address diversion?
>   

Operand access is by means of a callback, so yes.  In kvm's use, it's 
used to access guest memory, so it modified the addresses before reading 
or writing.

-- 
error compiling committee.c: too many arguments to function

