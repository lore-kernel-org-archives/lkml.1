Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYFSKKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYFSKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYFSKKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:10:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35783 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbYFSKKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:10:44 -0400
Date: Thu, 19 Jun 2008 12:10:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] - Increase MAX_APICS for very large x86_64 configs
Message-ID: <20080619101030.GF15228@elte.hu>
References: <20080616170910.GA24930@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616170910.GA24930@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Increase the maximum number of apics when running very large 
> configurations. This patch has no affect on most systems.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

applied to tip/x86/uv - thanks Jack.

> The patch has no effect on any 32-bit kernel. It adds ~4k to the size 
> of 64-bit kernels but only if NR_CPUS > 255.
> 
> This is a repost of an earlier patch (4/16) that was implicated in a 
> random-qa failure. I have not been able to reproduce the failure using 
> the same boot args & config.  Best guess is that some other patch 
> caused random data corruption & this patch was a victim.

i have just re-tested the previously failing config on tip/master:

  http://redhat.com/~mingo/misc/config-Thu_Apr_17_10_17_14_CEST_2008.bad
  http://people.redhat.com/mingo/tip.git/README

and the good news is that it does not crash on bootup anymore. Perhaps 
one of Mike's fixes/improvements did the trick?

Nevertheless i'll keep an eye on this change and wont propagate it to 
linux-next for a few days to make sure it's all robust on a wide range 
of x86 testsystems.

	Ingo
