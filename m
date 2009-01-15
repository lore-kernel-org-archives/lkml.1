Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZAOJHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZAOJHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZAOJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:07:00 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:50653 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZAOJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jA5glBzRmV81Wo6+3LZtiOYOLTijo0wpg9XH4el1Jt3gT2m2S98tQApBQ3rAykzeM8
         BZwgeXyaIk74bTd2iWCbZ2FvWl2gTm+TZwSv2gRiKxZHYjvo9OJItQexsEvdn6xz4HNu
         Tdtv9R+Yz9kruoRiQpKr2y9G9uJ/qhLj8QTA4=
Date: Thu, 15 Jan 2009 09:06:50 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: Badalian Vyacheslav <slavon@bigtelecom.ru>, Chris Caputo <ccaputo@alt.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115090650.GF4190@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <496EE1D4.6010709@bigtelecom.ru> <20090115080921.GC4190@ff.dom.local> <200901151101.15397.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151101.15397.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:01:14AM +0200, Denys Fedoryschenko wrote:
...
> Jarek, can you give me exact name of patch or link to it?
> I will test it on production.
> And i am interested in searching, what is a problem.

If there is nothing better I could recommend the patch below for
-stable (2.6.28), when it's tested.

Thanks,
Jarek P.
---

diff -Nurp a2.6.27.7/net/sched/sch_htb.c b2.6.27.7/net/sched/sch_htb.c
--- a2.6.27.7/net/sched/sch_htb.c	2008-12-11 08:16:16.000000000 +0000
+++ b2.6.27.7/net/sched/sch_htb.c	2008-12-15 10:44:32.000000000 +0000
@@ -924,6 +924,7 @@ static struct sk_buff *htb_dequeue(struc
 		}
 	}
 	sch->qstats.overlimits++;
+	qdisc_watchdog_cancel(&q->watchdog);
 	qdisc_watchdog_schedule(&q->watchdog, next_event);
 fin:
 	return skb;
