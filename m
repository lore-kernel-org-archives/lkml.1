Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbXKQRvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbXKQRvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbXKQRvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:51:16 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:51179 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956AbXKQRvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:51:15 -0500
Message-Id: <473EE2BE.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sat, 17 Nov 2007 12:46:54 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH v3 17/17] (Avoid overload)
References: <20071117062104.177779113@goodmis.org>
 <20071117062405.792778237@goodmis.org>
 <20071117063318.GA31442@goodmis.org>
In-Reply-To: <20071117063318.GA31442@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sat, Nov 17, 2007 at  1:33 AM, in message
<20071117063318.GA31442@goodmis.org>, Steven Rostedt <rostedt@goodmis.org>
wrote: 
 
> -	if ((p->prio >= rq->rt.highest_prio)
> -	    && (p->nr_cpus_allowed > 1)) {
> +	if (unlikely(rt_task(rq->curr))) {
>  		int cpu = find_lowest_rq(p);
>  
>  		return (cpu == -1) ? task_cpu(p) : cpu;

We probably should leave the "p->nr_cpus_allowed > 1" in the conditional since it doesn't make sense to look if the task can't go anywhere.

-Greg

