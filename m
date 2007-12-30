Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXL3N2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXL3N2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXL3N2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:28:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXL3N2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:28:30 -0500
Date: Sun, 30 Dec 2007 14:19:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
Message-ID: <20071230131910.GE16946@elte.hu>
References: <1198466795.6323.12.camel@brick> <47773C2D.8070600@redhat.com> <47774314.9080406@zytor.com> <47775062.4070300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47775062.4070300@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> > Why is a macro better than an inline, and why the odd mIXed case?
> 
> I thought we can use macro because it just check a bit mask. And if we 
> use this as a macro, it will be defined in #ifdef block at the top of 
> kprobes.c. It is simple in this case. I know the inline is better than 
> the macro, it can check the type of arguments. If you would like to 
> use inline, how about this?

yes, we prefer inlines for just about everything. We have reoccuring 
regressions due to macro side-effects, lack of type and argument 
checking - and the simplest maintenance policy is to just never 
introduce new macros. Macros also played an active role in creating our 
current include file dependencies spaghetti. So unless there are very, 
very strong reasons in favor of adding a macro, please always use 
inlines.

	Ingo
