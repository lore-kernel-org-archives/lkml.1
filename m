Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZDHC1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZDHC1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZDHC1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:27:32 -0400
Received: from mail.kolorific.com ([61.63.28.39]:43114 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZDHC1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:27:32 -0400
Date: Wed, 8 Apr 2009 10:27:23 +0800
From: "figo.zhang" <figo.zhang@kolorific.com>
To: =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH]kernel/sched_fair.c: the comment of the
 calc_delta_fair() maybe not correctly
In-Reply-To: <20090407165736.GI12226@hack>
References: <20090407063306.64659F50054@mail.kolorific.com>
	<20090407165736.GI12226@hack>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Message-Id: <20090408022723.22EC7F50054@mail.kolorific.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the comment of the calc_delta_fair() maybe not correctly, should be
delta *= NICE_0_LOAD/se->load

Signed-off-by: figo.zhang <figo.zhang@kolorific.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..5134b45 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -386,7 +386,7 @@ int sched_nr_latency_handler(struct ctl_table
*table, int write, #endif
 
 /*
- * delta /= w
+ * delta *= NICE_0_LOAD/se->load
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)




Wed, 8 Apr 2009 00:57:36 +0800
Américo Wang <xiyou.wangcong@gmail.com> :

> On Tue, Apr 07, 2009 at 02:33:06PM +0800, figo.zhang wrote:
> >the comment of the calc_delta_fair() maybe not correctly, should be
> >delta *= NICE_O_LOAD/se->load
> >
> >Signed-off-by: figo.zhang <figo.zhang@kolorific.com>
> 
> Agreed.
> 
> But...
> 
> 
> >
> >diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> >index 3816f21..5134b45 100644
> >--- a/kernel/sched_fair.c
> >+++ b/kernel/sched_fair.c
> >@@ -386,7 +386,7 @@ int sched_nr_latency_handler(struct ctl_table
> >*table, int write, #endif
> > 
> > /*
> >- * delta /= w
> >+ * delta *= NICE_O_LOAD/se->load
> 
> Is that an 'O' or '0'(zero)? It looks like an 'O' for me ...
> Obviously, it should be '0' (zero). :)
> 
> 
> >  */
> > static inline unsigned long
> > calc_delta_fair(unsigned long delta, struct sched_entity *se)
> >--
> >To unsubscribe from this list: send the line "unsubscribe
> >linux-kernel" in the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> 

