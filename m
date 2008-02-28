Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYB1TSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYB1TSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbYB1TSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:18:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbYB1TSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:18:39 -0500
Date: Thu, 28 Feb 2008 20:18:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080228191824.GA20019@elte.hu>
References: <20080228184407.GA7117@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228184407.GA7117@localhost.ift.unesp.br>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> I want to report a bad interactivity which happened in my desktop 
> running the latest kernel (2.6.25-rc3-00081-g7704a8b).
> 
> I tried to play 'flightgear' and the desktop became _very_ slow while 
> flightgear was "loading scenery objects" (a task which never finished 
> and I could not play it).
> 
> The desktop is a P4 @ 3.0 GHz, 512MB, with the nv graphics driver.

yes, but this means you run the soft-3D driver under Xorg, right? That 
is known to starve its clients. The stats you sent show no worse than a 
few tens of msecs delays caused by CPU scheduling itself:

  mrxvt (3730, #threads: 1)
  se.wait_max                        :            18.679129

so the scheduler kept things within the ~40 msecs default latency 
target:

  .sysctl_sched_latency                    : 40.000000

	Ingo
