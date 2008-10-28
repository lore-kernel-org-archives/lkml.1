Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYJ1KUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYJ1KUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJ1KUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:20:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYJ1KUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:20:06 -0400
Date: Tue, 28 Oct 2008 11:19:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: fix irqs on/off ip tracing
Message-ID: <20081028101939.GA19628@elte.hu>
References: <20081028101458.GA4964@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028101458.GA4964@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> 81d68a96 "ftrace: trace irq disabled critical timings" added wrappers around
> trace_hardirqs_on/off_caller. However these functions use
> __builtin_return_address(0) to figure out which function actually disabled
> or enabled irqs. The result is that we save the ips of trace_hardirqs_on/off
> instead of the real caller. Not very helpful.
> However since the patch from Steven the ip already gets passed. So use that
> and get rid of __builtin_return_address(0) in these two functions.
> 
> Cc: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/lockdep.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

good catch and nice cleanup, i've applied it to tip/core/urgent, 
thanks Heiko!

	Ingo
