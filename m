Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYHZUqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYHZUqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYHZUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:45:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60374 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYHZUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:45:42 -0400
Date: Tue, 26 Aug 2008 13:45:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rcu: spinlocks take an unsigned long flags
Message-ID: <20080826204534.GJ6656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1219780844.6069.5.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1219780844.6069.5.camel@brick>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:00:44PM -0700, Harvey Harrison wrote:
> Noticed by sparse:
> kernel/rcuclassic.c:719:2: error: incompatible types in comparison expression (different signedness)
> kernel/rcuclassic.c:727:2: error: incompatible types in comparison expression (different signedness)
> kernel/rcuclassic.c: In function ‘rcu_init_percpu_data’:
> kernel/rcuclassic.c:719: warning: comparison of distinct pointer types lacks a cast
> kernel/rcuclassic.c:727: warning: comparison of distinct pointer types lacks a cast

This is a duplicate of http://lkml.org/lkml/2008/8/18/497, sent in
by Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.

							Thanx, Paul

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  kernel/rcuclassic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 3f69189..743cf05 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -714,7 +714,7 @@ void rcu_check_callbacks(int cpu, int user)
>  static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
>  						struct rcu_data *rdp)
>  {
> -	long flags;
> +	unsigned long flags;
> 
>  	spin_lock_irqsave(&rcp->lock, flags);
>  	memset(rdp, 0, sizeof(*rdp));
> -- 
> 1.6.0.340.g84854
> 
> 
