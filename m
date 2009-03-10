Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZCJMlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZCJMlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZCJMln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:41:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZCJMlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:41:42 -0400
Date: Tue, 10 Mar 2009 13:41:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Free setup_irq() interrupt V2
Message-ID: <20090310124123.GF5794@elte.hu>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
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


* Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch adds a __free_irq() function for releasing 
> interrupts requested with setup_irq().
> 
> Without this patch we have no way of releasing such
> interrupts since free_irq() today tries to kfree()
> the irqaction passed with setup_irq().
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Changes since V1:
>  - break out a __free_irq() function, thanks Ingo! 

Looks good. Could you please send it against the latest genirq 
tree:

  http://people.redhat.com/mingo/tip.git/README

as your patch does not apply cleanly anymore:

  1 out of 3 hunks FAILED -- rejects in file kernel/irq/manage.c

>  Why again are we not using struct list_head for the irqaction list?

irq_desc size mostly.

	Ingo
