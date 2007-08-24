Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXHXBnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXHXBnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765420AbXHXBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 21:43:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:41309 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765241AbXHXBnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 21:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OG+DsMlL+SApNdRiyBdZQoHU/nvc1RZSNrleBGVxb7p/MFxLgQRTmseV9lK6u8ymtmpWii2vo2b7LdShAoagwXKoJboJhxhSb89xDQIjrQOEGhf/Hlm0R1O/imK7KdRx+3nckAaIKxtPmrl6rL9/+0W1CVE3CKHhXWZ8b/KJDlE=
Message-ID: <3bd6b93c0708231843m1e94e192i6a806ce18c266f69@mail.gmail.com>
Date: Thu, 23 Aug 2007 21:43:20 -0400
From: "Bruce Ashfield" <bruce.ashfield@windriver.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7, v2.6.20.16
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070823094346.GA26281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070823094346.GA26281@elte.hu>
X-Google-Sender-Auth: 4371d14059d23d99
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> By popular demand, here is release -v20 of the CFS scheduler. It is a
> full backport of the latest & greatest v2.6.23-rc3 CFS code to
> v2.6.22.5, v2.6.21.7 and v2.6.20.16. The patches can be downloaded from
> the usual place:

Ingo,

Great to see the older kernels updated, thanks for the patches.
I've got a bit of a modified 2.6.21.7, but when I built with
CONFIG_FAIR_GROUP_SCHED=y, I need the following change
to make things right (On a quick glance, my change matches the
2.6.23-rc3 code). Then again, I may just be doing something
stupid.

My apologies in advance if gmail decides to mangle the patch.

--- a/kernel/sched_fair.c.orig	2007-08-23 21:25:08.000000000 -0400
+++ a/kernel/sched_fair.c	2007-08-23 21:25:18.000000000 -0400
@@ -1057,7 +1057,7 @@ static void task_new_fair(struct rq *rq,
  */
 static void set_curr_task_fair(struct rq *rq)
 {
-	struct sched_entity *se = &rq->curr.se;
+	struct sched_entity *se = &rq->curr->se;

 	for_each_sched_entity(se)
 		set_next_entity(cfs_rq_of(se), se);



-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
