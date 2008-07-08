Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYGHFAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYGHFAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYGHFAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:00:42 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:47404 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751233AbYGHFAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:00:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ht63ElEYQyQC9eYPJtbLBYrXknNR1Mn5N2icRMePFh/7pNIpZbkjg28YXnfB45aJac6dATTGApW5v5PNxszxlNWWiCi5r0qPUMDR+mA4df+MVrIXsWK6oMP9hxYf9XwjGuQFzoDQN4tTz3ZnEOV4t1Nd9fsfkS1cbFOuYeyoogY=  ;
X-YMail-OSG: 8TwH7HYVM1nS7yY2ng8QUYshjS7lvq3jBEyUCVLOxVkfbM2tHBDKEKiV1GNeCaJPusVE.OFdgtsmInlYZEuzijW79XIautBMSMlaC_XYgACi0T2kz3xGsKT03tEhhjXGj9Q-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 2/3] sched: terminate newidle balancing once at least one task has moved over
Date: Tue, 8 Jul 2008 15:00:17 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, peterz@infradead.org, npiggin@suse.de, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <20080627202955.3829.78937.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080627202955.3829.78937.stgit@lsg.lsg.lab.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081500.18245.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 June 2008 06:29, Gregory Haskins wrote:
> Inspired by Peter Zijlstra.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

What happened to the feedback I sent about this?

It is still nack from me.


> ---
>
>  kernel/sched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 56722b1..0b9f90e 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2863,6 +2863,10 @@ static int move_tasks(struct rq *this_rq, int
> this_cpu, struct rq *busiest, max_load_move - total_load_moved,
>  				sd, idle, all_pinned, &this_best_prio);
>  		class = class->next;
> +
> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
> +			break;
> +
>  	} while (class && max_load_move > total_load_moved);
>
>  	return total_load_moved > 0;
>
> --
