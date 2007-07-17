Return-Path: <linux-kernel-owner+w=401wt.eu-S933515AbXGQRRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515AbXGQRRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbXGQRQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:16:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbXGQRQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:16:52 -0400
Date: Tue, 17 Jul 2007 19:16:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Kent <raven@themaw.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717171643.GB7905@elte.hu>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <1184671021.3188.51.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184671021.3188.51.camel@raven.themaw.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Kent <raven@themaw.net> wrote:

> > ah! It passes in a low-res time source into a high-res time interface 
> > (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> > time(NULL) + 2, or change it to:
> > 
> > 	gettimeofday(&wait, NULL);
> > 	wait.tv_sec++;
> 
> OK, I'm with you, hi-res timer.
> But even so, how is the time in the past after adding a second.
> 
> Is it because I'm not setting tv_nsec when it's close to a second 
> boundary, and hence your recommendation above?

yeah, it looks a bit suspicious: you create a +1 second timeout out of a 
1 second resolution timesource. I dont yet understand the failure mode 
though that results in that looping and in the 30% CPU time use - do you 
understand it perhaps? (and automount is still functional while this is 
happening, correct?)

	Ingo
