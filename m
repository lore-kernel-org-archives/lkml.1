Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0AOW2M (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167Ab0AOW2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:28:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45944 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab0AOW2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:28:09 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: maneesh@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263554284.4244.396.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
	 <1263551607.4244.379.camel@laptop>  <20100115110547.GB3660@in.ibm.com>
	 <1263553955.4244.393.camel@laptop>  <1263554284.4244.396.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 14:27:51 -0800
Message-Id: <1263594471.5007.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-15 at 12:18 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 12:12 +0100, Peter Zijlstra wrote:
...
> > 
> > Adding the probe uses the fact that (most) executable mappings are
> > MAP_PRIVATE and CoWs a private copy of the page with the modified ins,
> > right?

We've just used access_process_vm() to insert the breakpoint
instruction.  (If there are situations where that's not appropriate,
please advise.)

> 
> Does it clean up the CoW'ed page on removing the probe?

If I understand your question, the answer is no.  We make no attempt to
reclaim COW'ed pages, even after all the probes have been removed.  In
fact, once the first probe is hit and the XOL vma is created, the XOL
vma hangs around for the life of the process.

> Does that
> account for userspace having made other changes in between installing
> and removing the probe (for PROT_WRITE mappings obviously)?

We don't attempt the aforementioned cleanup, so I think the answer is
"N/A."

Jim

