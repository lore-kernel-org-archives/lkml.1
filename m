Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYDBTC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYDBTC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYDBTCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:02:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43920 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbYDBTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:02:20 -0400
Date: Wed, 2 Apr 2008 12:02:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Hugh Dickins <hugh@veritas.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EMM: Fix rcu handling and spelling
Message-ID: <20080402190218.GI9333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <1207084480.29991.2.camel@lappy> <20080401213811.GD8558@linux.vnet.ibm.com> <Pine.LNX.4.64.0804021142350.28436@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021142350.28436@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:43:02AM -0700, Christoph Lameter wrote:
> Subject: EMM: Fix rcu handling and spelling
> 
> Fix the way rcu_dereference is done.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/rmap.h |    2 +-
>  mm/rmap.c            |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/rmap.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rmap.h	2008-04-02 11:41:58.737866596 -0700
> +++ linux-2.6/include/linux/rmap.h	2008-04-02 11:42:08.282029661 -0700
> @@ -91,7 +91,7 @@ static inline void page_dup_rmap(struct 
>   * when the VM removes references to pages.
>   */
>  enum emm_operation {
> -	emm_release,		/* Process existing, */
> +	emm_release,		/* Process exiting, */
>  	emm_invalidate_start,	/* Before the VM unmaps pages */
>  	emm_invalidate_end,	/* After the VM unmapped pages */
>   	emm_referenced		/* Check if a range was referenced */
> Index: linux-2.6/mm/rmap.c
> ===================================================================
> --- linux-2.6.orig/mm/rmap.c	2008-04-02 11:41:58.737866596 -0700
> +++ linux-2.6/mm/rmap.c	2008-04-02 11:42:08.282029661 -0700
> @@ -303,7 +303,7 @@ EXPORT_SYMBOL_GPL(emm_notifier_register)
>  int __emm_notify(struct mm_struct *mm, enum emm_operation op,
>  		unsigned long start, unsigned long end)
>  {
> -	struct emm_notifier *e = rcu_dereference(mm)->emm_notifier;
> +	struct emm_notifier *e = rcu_dereference(mm->emm_notifier);
>  	int x;
> 
>  	while (e) {
> @@ -317,7 +317,7 @@ int __emm_notify(struct mm_struct *mm, e
>  		 * emm_notifier contents (e) must be fetched after
>  		 * the retrival of the pointer to the notifier.
>  		 */
> -		e = rcu_dereference(e)->next;
> +		e = rcu_dereference(e->next);
>  	}
>  	return 0;
>  }
> 
