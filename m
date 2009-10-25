Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZJYLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZJYLsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZJYLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 07:48:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZJYLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 07:48:18 -0400
Subject: Re: [PATCH 2/3] sched: Add aggressive load balancing for certain
 situations
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1256457686.7356.4.camel@laptop>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>  <1256457686.7356.4.camel@laptop>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 12:48:15 +0100
Message-Id: <1256471295.7356.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 09:01 +0100, Peter Zijlstra wrote:
> 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 4e777b4..fe9b95b 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1246,7 +1246,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >   */
> >  static struct sched_group *
> >  find_idlest_group(struct sched_domain *sd, struct task_struct *p,
> > -               int this_cpu, int load_idx)
> > +               int this_cpu, int load_idx, int agressive)
> >  {
> 
> can't we fold that into load_idx? like -1 or something?

A better alternative might be passing imbalance along instead.

