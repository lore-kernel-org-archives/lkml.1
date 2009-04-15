Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZDOAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZDOAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZDOAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:31:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37218 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDOAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:31:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 3/4] ftrace: add max execution time mesurement to workqueue tracer
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090414114032.GA5994@nowhere>
References: <20090414102802.C637.A69D9226@jp.fujitsu.com> <20090414114032.GA5994@nowhere>
Message-Id: <20090415092629.AC1E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 09:31:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > May I explain my expected usage scenario?
> > 
> > firstly, the developer check this stastics and nortice strage result. secondly
> > the developer monitor workqueue activety by event-tracer.
> > (it provide per work activety, maybe event filter feature is useful)
> > 
> > Yes, I have to agree my last patch description is too poor.
> > but I think my expected scenario is't so insane.
> > 
> > Next, I hope to explain why I don't choice adding per work stastics.
> > struct work can put in stack and it's short lived object.
> > then, it isn't proper "stastics" target.
> > 
> > I like my approach or histogram approach (suggested by ingo).
> > 
> > May I ask your feeling to my usage scenario?
> 
> Ok, I understand. This is a coupling of statistical tracing
> and batch raw event tracing.
> But a statistical view for every work per workqueue would
> be definetly more helpful.
> Beeing forced to look at the raw batch of work events involves
> more searching in the traces and more headaches.
> 
> With your patch, we only see the worst time case on a workqueue while
> it would be better to find all the works which are encumbering
> a workqueue, sorted by latency importance.
> 
> I agree with the fact that it's not so easy though, because the works
> can be allocated on the stack as you said.

ok.
now, We agreed my patch works enough and your proposal is better, right?
if so, we can discuss separetely per-work stastics and per-workqueue stastics.

I submitted per-workqueue stastics v3 today's later (or tomorrow).



