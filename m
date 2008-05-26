Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYEZKyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYEZKyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYEZKx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:53:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYEZKx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:53:57 -0400
Date: Mon, 26 May 2008 12:53:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-ID: <20080526105332.GA484@elte.hu>
References: <20080524165828.GA29993@elte.hu> <20080524104024.a33116a3.akpm@linux-foundation.org> <483A7663.4000700@jp.fujitsu.com> <20080526084709.GA2182@elte.hu> <20080526015232.5faac5bb.akpm@linux-foundation.org> <483A9050.5000206@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A9050.5000206@jp.fujitsu.com>
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


* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Although I have not considered how to implement proper fix deeply, I 
> don't think it's so simple. For example, current pciehp is doing like 
> this:
>
> (1) some initialization
> (2) request_irq()
> (3) issue command
> (4) initialize slot data structure
>
> Maybe we want to do (2) after (4) to fix the problem. But if we simply 
> move (2) after (4), we cannot detect the command completion event at 
> (3) and it will cause command timeout.
>
> It's just an example, and there might be other things like this. This 
> example might be fixed simply, but all my worry is that fixing this 
> quickly might cause another regressions. This is why I think Ingo's 
> approach is better in a short term.
>
> And another reason is I'm very nervous because I already caused many 
> problems in pciehp since 2.6.26-rcX... :(

no need to feel bad about it - i dont think what i reported is a serious 
problem in any fashion - it's a very narrow race as long as DEBUG_SHIRQ 
is off that very likely wont trigger in practice. We can do a minimal 
fix in v2.6.26 and something more structural in v2.6.27.

	Ingo
