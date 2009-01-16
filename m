Return-Path: <linux-kernel-owner+w=401wt.eu-S936237AbZAPO2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936237AbZAPO2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936154AbZAPOZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:25:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36461 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934898AbZAPOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:25:26 -0500
Date: Fri, 16 Jan 2009 15:25:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
Message-ID: <20090116142514.GA1269@elte.hu>
References: <49704DF6.8040205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49704DF6.8040205@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mike Travis <travis@sgi.com> wrote:

> commit b758cdbee5da0b8fb7e34a68651e6ccc5310b48a
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Thu Jan 15 16:29:16 2009 -0800
> 
>     work_on_cpu: Use our own workqueue.
>     
>     Impact: remove potential circular lock dependency with generic kevent workqueue
>     
>     Annoyingly, some places we want to use work_on_cpu are already in
>     workqueues.  As per Ingo's suggestion, we create a different workqueue
>     for work_on_cpu.

btw., that's a nice fix - were you able to reproduce any of the lockdep 
asserts that i got in testing, and did those go away with this patch?

If yes then that's nice and makes work_on_cpu() a lot more usable IMO.

If not then that should generally be declared in the pull request: 
"beware, different approach than before but might still trigger lockdep 
warnings".

	Ingo
