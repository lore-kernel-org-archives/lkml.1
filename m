Return-Path: <linux-kernel-owner+w=401wt.eu-S965933AbZLHTwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933AbZLHTwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965922AbZLHTwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:52:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965919AbZLHTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:52:16 -0500
Date: Tue, 8 Dec 2009 20:52:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] net/sctp/sysctl.c: Remove dead strategy handler
Message-ID: <20091208195209.GA30947@elte.hu>
References: <20091205.193505.193701079.davem@davemloft.net>
 <20091208194530.GA24530@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208194530.GA24530@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hi Dave,
> 
> i just switched to today's -git tree and there's this new build failure 
> on x86:
> 
>  net/sctp/sysctl.c:251: error: unknown field 'strategy' specified in initializer
>  net/sctp/sysctl.c:251: error: 'sysctl_intvec' undeclared here (not in a function)
> 
> havent looked into it yet - config attached.

That's interaction with the strategy handler removal from Eric. I think 
the patch below will do the trick - the callsites have been updated 
already to use proc_handler, so ->handler was a dead field.

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 419e1e9..832590b 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -248,7 +248,6 @@ static ctl_table sctp_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &one,
 		.extra2		= &rwnd_scale_max,
 	},
