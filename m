Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZFHUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZFHUwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZFHUws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:52:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFHUwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:52:47 -0400
Date: Mon, 8 Jun 2009 22:52:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: note task_struct bloat
Message-ID: <20090608205237.GA13343@elte.hu>
References: <Pine.LNX.4.64.0906081841580.7100@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906081841580.7100@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Add belated comment to LATENCYTOP help text, making clear that this is a
> much more expensive option than you might think: along with the options
> it selects, it may add more than 4000 bytes to each struct task_struct
> (on 64-bit; more than 2000 on 32-bit), effectively quadrupling the size
> of an otherwise lean task_struct (in fact, slab on x86_64 fits only 1
> in two pages, whereas it fits 5 in two pages without LATENCYTOP=y).
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  lib/Kconfig.debug |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- 2.6.30-rc8/lib/Kconfig.debug	2009-05-16 10:26:16.000000000 +0100
> +++ linux/lib/Kconfig.debug	2009-06-08 18:30:50.000000000 +0100
> @@ -826,6 +826,10 @@ config LATENCYTOP
>  	  Enable this option if you want to use the LatencyTOP tool
>  	  to find out which userspace is blocking on what kernel operations.
>  
> +	  Note: enabling this option may add more than 4000 bytes to each
> +	  task_struct on a 64-bit kernel (more than 2000 bytes to task_struct
> +	  on a 32-bit kernel), multiplying its memory usage by 4 or even 5.
> +

Ah, nasty - quadratics in action.

This should be improved really. Arjan, what would it take to convert 
latencytop over to perfcounters? What would be ideal software 
counter for this?

	Ingo
