Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXI3HVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXI3HVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 03:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXI3HVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 03:21:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbXI3HVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 03:21:14 -0400
Date: Sun, 30 Sep 2007 09:20:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Luebbe <jluebbe@lasnet.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] fix console change race exposed by CFS
Message-ID: <20070930072056.GA18108@elte.hu>
References: <1191084471.24185.11.camel@polaris>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1191084471.24185.11.camel@polaris>
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


* Jan Luebbe <jluebbe@lasnet.de> wrote:

> From: Jan Lübbe <jluebbe@lasnet.de>
> 
> The new behaviour of CFS exposes a race which occurs if a switch is
> requested when vt_mode.mode is VT_PROCESS.
> 
> The process with vc->vt_pid is signaled before vc->vt_newvt is set. This
> causes the switch to fail when triggered by the monitoing process
> because the target is still -1.
> 
> Signed-off-by: Jan Lübbe <jluebbe@lasnet.de>

nifty! I'm wondering what the symptoms of this bug were - how did you 
notice it? Also, i'm wondering how you managed to debug this - looks 
quite hard to trigger this race, right?

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
