Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbXJGJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbXJGJIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 05:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXJGJIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 05:08:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbXJGJI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 05:08:29 -0400
Date: Sun, 7 Oct 2007 11:08:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] forcedeth: several proposed updates for testing
Message-ID: <20071007090808.GB733@elte.hu>
References: <20071006151250.GA17020@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006151250.GA17020@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> * I feel TX NAPI is a useful tool, because it provides an independent TX
>   process control point and system load feedback point.
>   Thus I felt this was slightly superior to tasklets.

/me agrees violently

btw., when i played with this tunable under -rt:

 enum {
         NV_OPTIMIZATION_MODE_THROUGHPUT,
         NV_OPTIMIZATION_MODE_CPU
 };
 static int optimization_mode = NV_OPTIMIZATION_MODE_THROUGHPUT;

the MODE_CPU one gave (much) _higher_ bandwidth. The queueing model in 
forcedeth seemed to be not that robust and i think a single queueing 
model should be adopted instead of this tunable. (which i think just hid 
some bug/dependency) But i never got to the bottom of it so it's just 
the impression i got.

	Ingo
