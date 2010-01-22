Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008Ab0AVHYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0AVHYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934Ab0AVHYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:24:15 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34921 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0AVHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:24:14 -0500
Date: Fri, 22 Jan 2010 12:54:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes [ Summary of Comments
	and actions to be taken ]
Message-ID: <20100122072402.GA7440@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100122070232.GA2975@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122070232.GA2975@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:32:32PM +0530, Srikar Dronamraju wrote:
> Here is a summary of the Comments and actions that need to be taken for
> the current uprobes patchset. Please let me know if I missed or
> misunderstood any of your comments.  
> 
> 1. Uprobes depends on trap signal.
> 	Uprobes depends on trap signal rather than hooking to the global
> die notifier. It was suggested that we hook to the global die notifier.
> 
> 	In the next version of patches, Uprobes will use the global die
> 	notifier and look at the per-task count of the probes in use to
> 	see if it has to be consumed.
> 
> 	However this would reduce the ability of uprobe handlers to
> 	sleep. Since we are dealing with userspace, sleeping in handlers
> 	would have been a good feature. We are looking at ways to get
> 	around this limitation.

We could set a TIF_ flag in the notifier to indicate a breakpoint hit
and process it in task context before the task heads into userspace.

Ananth
