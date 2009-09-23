Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZIWMud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZIWMud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZIWMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:50:31 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:56164 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZIWMua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B7htspIhLDxE5LrBL/HLyEP7JhlurSgrhGd5y+CQ9b5OSGq7XNGWng34cZtGFfCzAj
         tnN90tYoC/D3MKUbCXCz20w8liOHrXs7Azvdb2KVy5r+c6gJr34qbz5n9taIW8TTA3+9
         4BlIKbonxXbCPll6sdNvayfhw2yoeh+RPm/DE=
MIME-Version: 1.0
In-Reply-To: <63386a3d0909230533o7ab835ecubc8d074fea97642f@mail.gmail.com>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909230533o7ab835ecubc8d074fea97642f@mail.gmail.com>
Date: Wed, 23 Sep 2009 14:50:31 +0200
Message-ID: <63386a3d0909230550p2443ff14me39bf8c964abfd5d@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23 Linus Walleij <linus.ml.walleij@gmail.com>:

> In file included from /home/linus/src/linux-trees/linux-2.6/kernel/sched.c:1856:
> /home/linus/src/linux-trees/linux-2.6/kernel/sched_edf.c: In function
> 'pick_next_task_edf':
> /home/linus/src/linux-trees/linux-2.6/kernel/sched_edf.c:435: error:
> implicit declaration of function 'hrtick_enabled'

Nah, no complex explanations... it's just compiled out but still used,
here's another patch:

diff --git a/kernel/sched_edf.c b/kernel/sched_edf.c
index cdec433..198ad6b 100644
--- a/kernel/sched_edf.c
+++ b/kernel/sched_edf.c
@@ -431,9 +431,11 @@ struct task_struct *pick_next_task_edf(struct rq *rq)
        BUG_ON(!edf_se);

        p = edf_task_of(edf_se);
-       p->se.exec_start = rq->clock;
+       p->se.exec_start = rq->clock
+#ifdef CONFIG_SCHED_HRTICK
        if (hrtick_enabled(rq))
                start_hrtick_edf(rq, p);
+#endif

        return p;
 }

Yours,
Linus Walleij
