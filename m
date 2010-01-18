Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340Ab0ARHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0ARHqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177Ab0ARHqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:46:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0ARHqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:46:19 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B53661A.9090907@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>
	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com>
	 <1263740593.557.20967.camel@twins>  <4B53661A.9090907@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:45:52 +0100
Message-ID: <1263800752.4283.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 21:33 +0200, Avi Kivity wrote:
> On 01/17/2010 05:03 PM, Peter Zijlstra wrote:
> >
> >> btw, an alternative is to require the caller to provide the address
> >> space for this.  If the caller is in another process, we need to allow
> >> it to play with the target's address space (i.e. mmap_process()).  I
> >> don't think uprobes justifies this by itself, but mmap_process() can be
> >> very useful for sandboxing with seccomp.
> >>      
> > mmap_process() sounds utterly gross, one process playing with another
> > process's address space.. yuck!
> >    
> 
> This is debugging.  We're playing with registers, we're playing with the 
> cpu, we're playing with memory contents.  Why not the address space as well?

Because you want thins go to be as transparent as possible in order to
avoid heisenbugs. Sure we cannot avoid everything, but we should avoid
everything we possibly can.

Also, aside of the VDSO, we simply do not force map things into address
spaces (and like said before, I think the VDSO stinks for doing that)
and I think we don't want to create (more) precedents in this case.



