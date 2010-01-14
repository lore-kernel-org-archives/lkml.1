Return-Path: <linux-kernel-owner+w=401wt.eu-S932389Ab0ANWn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0ANWn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356Ab0ANWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:43:54 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59587 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab0ANWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:43:53 -0500
Subject: Re: [RFC] [PATCH 3/7] Execution out of line (XOL)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263467318.4244.289.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
	 <1263467318.4244.289.camel@laptop>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 14:43:17 -0800
Message-Id: <1263508997.4875.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-01-14 at 12:08 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> > Execution out of line (XOL)
> > 
> > Slot allocation mechanism for Execution Out of Line strategy in User
> > space breakpointing Inftrastructure. (XOL)
> > 
> > This patch provides slot allocation mechanism for execution out of
> > line strategy for use with user space breakpoint infrastructure.
> > This patch requires utrace support in kernel.
> > 
> > This patch provides five functions xol_get_insn_slot(),
> > xol_free_insn_slot(), xol_put_area(), xol_get_area() and
> > xol_validate_vaddr().
> > 
> > Current slot allocation mechanism:
> > 1. Allocate one dedicated slot per user breakpoint.
> > 2. If the allocated vma is completely used, expand current vma.
> > 3. If we cant expand the vma, allocate a new vma.
> 
> 
> Say what?
> 
> I see the text, but non of it makes any sense at all.
> 

Yeah, there's not a lot of context there.  I hope it will make more
sense if you read section 1.1 of Documentation/uprobes.txt (patch #6).
Or look at get_insn_slot() in kprobes, and understand that we're trying
to do something similar in uprobes, where the instruction copies have to
reside in the user address space of the probed process.

Jim

