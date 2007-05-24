Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbXEXJ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbXEXJ7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXEXJ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:58:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXEXJ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:58:54 -0400
Date: Thu, 24 May 2007 11:58:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate
Message-ID: <20070524095837.GA15689@elte.hu>
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net> <464ED258.2010903@users.sourceforge.net> <20070520203123.5cde3224.akpm@linux-foundation.org> <20070524075835.GC21138@elte.hu> <465551DC.4060603@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465551DC.4060603@users.sourceforge.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Righi <righiandr@users.sourceforge.net> wrote:

> Actually it seems that SIGKILLs are not printed. In 
> get_signal_to_deliver() we have:
> 
> [snip]
> @@ -1843,6 +1879,8 @@ relock:
>  		 * Anything else is fatal, maybe with a core dump.
>  		 */
>  		current->flags |= PF_SIGNALED;
> +		if ((signr != SIGKILL) && print_fatal_signals)
> +			print_fatal_signal(regs, signr);

yeah. Either i implemented that and forgot, or someone else implemented 
it. :)

	Ingo
