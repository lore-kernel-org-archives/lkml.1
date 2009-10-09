Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbZJINzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbZJINzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZJINzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:55:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47885 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbZJINzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:55:48 -0400
Date: Fri, 9 Oct 2009 06:55:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemleak: Check for NULL pointer returned by
	create_object()
Message-ID: <20091009135511.GB7893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com> <20091009093034.4365.34259.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009093034.4365.34259.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 10:30:34AM +0100, Catalin Marinas wrote:
> This patch adds NULL pointer checking in the early_alloc() function.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  mm/kmemleak.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index a617518..8bf765c 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -834,11 +834,14 @@ static void early_alloc(struct early_log *log)
>  	rcu_read_lock();
>  	object = create_object((unsigned long)log->ptr, log->size,
>  			       log->min_count, GFP_ATOMIC);
> +	if (!object)
> +		goto out;
>  	spin_lock_irqsave(&object->lock, flags);
>  	for (i = 0; i < log->trace_len; i++)
>  		object->trace[i] = log->trace[i];
>  	object->trace_len = log->trace_len;
>  	spin_unlock_irqrestore(&object->lock, flags);
> +out:
>  	rcu_read_unlock();
>  }
> 
> 
