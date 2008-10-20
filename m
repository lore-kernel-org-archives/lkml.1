Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJTHZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJTHZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYJTHZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:25:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYJTHZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:25:39 -0400
Date: Mon, 20 Oct 2008 09:25:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] Breaks the redundant loop in kernel/marker.c
Message-ID: <20081020072520.GE12131@elte.hu>
References: <48FC273B.3030300@cn.fujitsu.com> <20081020065205.GA12927@elte.hu> <48FC3083.8020104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC3083.8020104@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > hm, could you describe the necessity of this patch some more? This has 
> > the change to change behavior, which might even be a bugfix: is there 
> > any chance that the closure-loop in the e->ptype != NULL branch does not 
> > exit? Before your patch we'd continue the iteration - which _probably_ 
> > does not lead to any more matches (e->name is supposed to be unique).
> 
> Because e->name is unique in list, we don't need to continue the iteration
> after matched.
> This is a cleanup.

ok - it's useful to point this out in the changelog. You can use the 
"Impact:" header we started using recently:

    Impact: cleanup, no functionality changed

See for example this upstream commit:

| commit 07454bfff151d2465ada809bbaddf3548cc1097c
| Author: Thomas Gleixner <tglx@linutronix.de>
| Date:   Sat Oct 4 10:51:07 2008 +0200
|
|     clockevents: check broadcast tick device not the clock events device
|
|     Impact: jiffies increment too fast.
 
Mathieu, any objections against the patch?

	Ingo
