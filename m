Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYKPH77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYKPH77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYKPH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:59:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYKPH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:59:51 -0500
Date: Sun, 16 Nov 2008 08:59:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081116075928.GB530@elte.hu>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224948.134716055@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Add a new API trace_mark_tp(), which declares a marker within a 
> tracepoint probe. When the marker is activated, the tracepoint is 
> automatically enabled.
> 
> No branch test is used at the marker site, because it would be a 
> duplicate of the branch already present in the tracepoint.
> 
> Impact: new API.

i dont know.

I was actually hoping for markers (the in-kernel API) to go away 
completely - and be replaced with tracepoints.

Markers are the wrong design on several levels. They couple the kernel 
dynamically with unknown (to the kernel) entities - and that is 
causing complexity all around the place, clearly expressed in these 
patches of yours.

Tracepoints are much more specific - typed and enumerated function 
call callback points in essence - with some politeness that allows 
external instrumentation entities to attach to those callbacks.

Is there any usecase of markers that should not be converted to either 
tracepoints or to ftrace_printk() ?

	Ingo
