Return-Path: <linux-kernel-owner+w=401wt.eu-S1765388AbYD1I6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765388AbYD1I6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYD1I57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:57:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbYD1I56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:57:58 -0400
Date: Mon, 28 Apr 2008 01:57:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-Id: <20080428015723.e1632c45.akpm@linux-foundation.org>
In-Reply-To: <20080428084904.GA27056@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com>
	<20080427183926.acb66fff.akpm@linux-foundation.org>
	<20080428070946.GA4507@osiris.boeblingen.de.ibm.com>
	<20080428002853.1693e7fd.akpm@linux-foundation.org>
	<20080428075253.GB4507@osiris.boeblingen.de.ibm.com>
	<20080428081129.GC4507@osiris.boeblingen.de.ibm.com>
	<20080428083222.GA16963@elte.hu>
	<20080428084904.GA27056@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 10:49:04 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Apr 28, 2008 at 10:32:22AM +0200, Ingo Molnar wrote:
> > 
> > * Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > >  /* doms_cur_mutex serializes access to doms_cur[] array */
> > >  static DEFINE_MUTEX(doms_cur_mutex);
> > >  
> > > +static inline void lock_doms_cur(void)
> > > +{
> > > +	mutex_lock(&doms_cur_mutex);
> > > +}
> > 
> > > @@ -7813,8 +7811,10 @@ int arch_reinit_sched_domains(void)
> > >  	int err;
> > >  
> > >  	get_online_cpus();
> > > +	lock_doms_cur();
> > 
> > thanks, that looks a lot more clean already. May i ask for another 
> > thing, if you are hacking on this anyway? Please get rid of the 
> > lock_doms_cur() complication now that it's not conditional - an open 
> > coded mutex_lock(&sched_doms_mutex) looks more readable - it gives a 
> > clear idea about what's happening. Also, please rename sched_doms_mutex 
> > to something less tongue-twisting - such as sched_domains_mutex. Hm?
> 
> Your wish is my order:

heh, let's all boss Heiko around.

>  /* doms_cur_mutex serializes access to doms_cur[] array */
> -static DEFINE_MUTEX(doms_cur_mutex);
> +static DEFINE_MUTEX(sched_domains_mutex);

The comment refers to a no-longer-existing lock, and no longer correctly
describes the lock's usage.


