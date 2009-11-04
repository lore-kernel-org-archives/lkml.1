Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZKDHqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZKDHqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZKDHqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:46:08 -0500
Received: from ozlabs.org ([203.10.76.45]:33648 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZKDHqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:46:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] MM: slqb, fix per_cpu access
Date: Wed, 4 Nov 2009 18:15:52 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
References: <1257113578-1584-1-git-send-email-jirislaby@gmail.com> <200911022353.30524.rusty@rustcorp.com.au> <4AEEFB5D.9080009@gmail.com>
In-Reply-To: <4AEEFB5D.9080009@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041815.53431.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 02:01:41 am Jiri Slaby wrote:
> >> -	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
> >> +	struct delayed_work *_cache_trim_work = &per_cpu(cache_trim_work, cpu);
> >>  
> >>  	/*
> >>  	 * When this gets called from do_initcalls via cpucache_init(),
> >>  	 * init_workqueues() has already run, so keventd will be setup
> >>  	 * at that time.
> >>  	 */
> >> -	if (keventd_up() && cache_trim_work->work.func == NULL) {
> >> -		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
> >> -		schedule_delayed_work_on(cpu, cache_trim_work,
> >> +	if (keventd_up() && _cache_trim_work->work.func == NULL) {
> >> +		INIT_DELAYED_WORK(_cache_trim_work, cache_trim_worker);
> >> +		schedule_delayed_work_on(cpu, _cache_trim_work,
> >>  					__round_jiffies_relative(HZ, cpu));
> > 
> > How about calling the local var "trim"?
> > 
> > This actually makes the code more readable, IMHO.
> 
> Please ignore this version of the patch. After this I sent a new one
> which changes the global var name.

OK, sure.  It's not worth changing unless you were doing a rename anyway.

> So the local variable is untouched there. If you want me to perform the
> cleanup, let me know. In any case I'd make it trim_work instead of trim
> which makes more sense to me.

This is getting pedantic and marginal, but the word "work" already appears
everywhere this var is used.  Either "XXX->work", or "INIT_DELAYED_WORK(XXX"
or "scheduled_delayed_work_on(cpu, XXX".

That's why I think the word "work" in unnecessary.

Hope that clarifies why I preferred "trim".
Rusty.
