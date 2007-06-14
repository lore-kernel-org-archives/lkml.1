Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXFNVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXFNVTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXFNVTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:19:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33958 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbXFNVTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:19:03 -0400
Date: Thu, 14 Jun 2007 23:18:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: malc <av1474@comtv.ru>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
Message-ID: <20070614211828.GA21243@elte.hu>
References: <200703251159.03616.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org> <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru> <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru> <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* malc <av1474@comtv.ru> wrote:

> > the alternating balancing might be due to an uneven number of tasks 
> > perhaps? If you have 3 tasks on 2 cores then there's no other 
> > solution to achieve even performance of each task but to rotate them 
> > amongst the cores.
> 
> One task, one thread. I have also tried to watch fairly demanding 
> video (Elephants Dream in 1920x1080/MPEG4) with mplayer, and CFS moves 
> the only task between cores almost every second.

hm, mplayer is not running alone when it does video playback: Xorg is 
also pretty active. Furthermore, the task you are using to monitor 
mplayer counts too. The Core2Duo has a shared L2 cache between cores, so 
it is pretty cheap to move tasks between the cores.

> > well, precise/finegrained accounting patches have been available for 
> > years, the thing with CFS is that there we get them 'for free', 
> > because CFS needs those metrics for its own logic. That's why this 
> > information is much closer to reality now. But note: right now what 
> > is affected by the changes in the CFS patches is /proc/PID/stat 
> > (i.e. the per-task information that 'top' and 'ps' displays, _not_ 
> > /proc/stat) - but more accurate /proc/stat could certainly come 
> > later on too.
> 
> Aha. I see, it's just that integral load for hog is vastly improved 
> compared to vanilla 2.6.21 [...]

hm, which ones are improved? Could this be due to some other property of 
CFS? If your app relies on /proc/stat then there's no extra precision in 
those cpustat values yet.

i've Cc:-ed Balbir Singh and Dmitry Adamushko who are the main authors 
of the current precise accounting code in CFS. Maybe i missed some 
detail :-)

	Ingo
