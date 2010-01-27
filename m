Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139Ab0A0GyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0A0GyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039Ab0A0GyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:54:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:59023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0A0GyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:54:12 -0500
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes [ Summary of Comments
 and actions to be taken ]
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100122072402.GA7440@in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100122070232.GA2975@linux.vnet.ibm.com>
	 <20100122072402.GA7440@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 07:53:45 +0100
Message-ID: <1264575225.4283.1985.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 12:54 +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jan 22, 2010 at 12:32:32PM +0530, Srikar Dronamraju wrote:
> > Here is a summary of the Comments and actions that need to be taken for
> > the current uprobes patchset. Please let me know if I missed or
> > misunderstood any of your comments.  
> > 
> > 1. Uprobes depends on trap signal.
> > 	Uprobes depends on trap signal rather than hooking to the global
> > die notifier. It was suggested that we hook to the global die notifier.
> > 
> > 	In the next version of patches, Uprobes will use the global die
> > 	notifier and look at the per-task count of the probes in use to
> > 	see if it has to be consumed.
> > 
> > 	However this would reduce the ability of uprobe handlers to
> > 	sleep. Since we are dealing with userspace, sleeping in handlers
> > 	would have been a good feature. We are looking at ways to get
> > 	around this limitation.
> 
> We could set a TIF_ flag in the notifier to indicate a breakpoint hit
> and process it in task context before the task heads into userspace.

OK, so we can go play stack games in the INT3 interrupt handler by
moving to a non IST stack when it comes from userspace, or move kprobes
over to INT1 or something.

