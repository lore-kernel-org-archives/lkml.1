Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbXK2Lue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbXK2Lue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXK2LuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:50:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbXK2LuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:50:24 -0500
Date: Thu, 29 Nov 2007 12:50:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129115011.GA30208@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129105744.GI10577@elte.hu> <E1Ixhgf-0001CF-MC@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ixhgf-0001CF-MC@dorka.pomaz.szeredi.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > how come UML idled for 30 msecs here, while the workload was 
> > supposed to be CPU-bound? It's not IO bound anywhere, right? No SMP 
> > artifacts either, right?
> 
> Yes.  The UML kernel is UP, and I don't think 'date' or 'bash' want to 
> do any disk I/O.
> 
> Could disk I/O be blocking the tty?  I think UML uses separate threads 
> for these, but I don't know the details.

even if the workload is fully CPU bound externally - internally a 
request to the external (CPU-bound) thread will look like an asynchonous 
request - so small amounts of idle time can be within UML, legitimately. 
(for the amount of time it takes for the external thread to service the 
request)

30 msecs already sounds a bit excessive (this is on your T60 with 
Core2Duo, right?), and 1-2 seconds noticeable latency is definitely 
excessive.

	Ingo
