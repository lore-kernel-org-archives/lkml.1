Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZKPO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZKPO2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZKPO2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:28:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59183 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZKPO2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:28:16 -0500
Date: Mon, 16 Nov 2009 19:58:11 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7] hw-breakpoints: Rewrite the hw-breakpoints layer on
	top of perf events
Message-ID: <20091116142811.GA24341@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257474542-6648-1-git-send-email-fweisbec@gmail.com> <1257474542-6648-6-git-send-email-fweisbec@gmail.com> <20091108173107.GB4465@in.ibm.com> <20091112151947.GC5237@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112151947.GC5237@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 04:19:52PM +0100, Frederic Weisbecker wrote:
> On Sun, Nov 08, 2009 at 11:01:07PM +0530, K.Prasad wrote:
> > 
> > A few more observations....
> > 
> > int reserve_bp_slot(struct perf_event *bp)
> > {
> > ...
> > ....
> > 	if (!bp->attr.pinned) {
> > 		/*
> > 		 * If there are already flexible counters here,
> > 		 * there is at least one slot reserved for all
> > 		 * of them. Just join the party.
> > 		 *
> > 		 * Otherwise, check there is at least one free slot
> > 		 */
> > 		if (!slots.flexible && slots.pinned == HBP_NUM) {
> > 			ret = -ENOSPC;
> > 			goto end;
> > 		}
> > 
> > 	/* Flexible counters need to keep at least one slot */
> > 	} else if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
> > 		ret = -ENOSPC;
> > 		goto end;
> > 	}
> > ..
> > ...
> > }
> > 
> > It appears that you're reserving one slot for the non-pinned breakpoint
> > requests, which I'm afraid wouldn't play well with PPC64 (having one
> > DABR).
> 
> I don't understand what you mean. PPC64 has only one DABR, or...?
> 

Yes, PPC64 has just one DABR. And so this scheme will allow the first
request (be it 'pinned' or 'unpinned') to use the debug register? Sounds
fine.

Thanks,
K.Prasad

