Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXLJDXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXLJDXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXLJDXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:23:43 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:28574 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbXLJDXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:23:42 -0500
Message-Id: <475C69B7.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sun, 09 Dec 2007 22:18:31 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>, <rostedt@goodmis.org>,
       "Gregory Haskins" <GHaskins@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] sched: Fixed missed rt-balance points on
	priority shifts
References: <475BEE6B.BA47.005A.0@novell.com>
 <20071210024709.4760.68134.stgit@novell1.haskins.net>
In-Reply-To: <20071210024709.4760.68134.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sun, Dec 9, 2007 at  9:53 PM, in message
<20071210024709.4760.68134.stgit@novell1.haskins.net>, Gregory Haskins
<ghaskins@novell.com> wrote: 

> +		 * I have no doubt that this is the proper thing to do to make
> +		 * sure RT tasks are properly balanced.  What I cannot wrap my
> +		 * head around at this late hour is if issuing a reschedule()
> +		 * here may cause issues in other circumstances.  TBD
> +		 */
> +		if (!task_running(rq, p))
> +			resched_task(rq->curr);
> +	}

It dawned on me after I sent this that a further optimization here is to predicate the reschedule on whether we are overloaded.  In otherwords:

if (!task_running(rq, p) && rt_overloaded(rq))

Regards,
-Greg

