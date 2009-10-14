Return-Path: <linux-kernel-owner+w=401wt.eu-S934143AbZJNUkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143AbZJNUkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934087AbZJNUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:40:13 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:40972 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085AbZJNUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:40:10 -0400
Date: Wed, 14 Oct 2009 13:26:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
       jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 5/6] rcu: add rnp->blocked_tasks to tracing
Message-ID: <20091014202649.GC2395@feather>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
 <1255540559475-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255540559475-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:15:58AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_trace.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 4b31c77..f9d01a3 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -155,12 +155,13 @@ static const struct file_operations rcudata_csv_fops = {
>  
>  static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
>  {
> +	long gpnum;
>  	int level = 0;
>  	struct rcu_node *rnp;
>  
>  	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
>  		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
> -		   rsp->completed, rsp->gpnum, rsp->signaled,
> +		   rsp->completed, gpnum = rsp->gpnum, rsp->signaled,

Please don't hide this or any other assignment in the middle of a print
statement.  Just put it immediately preceeding the statement.

- Josh Triplett
