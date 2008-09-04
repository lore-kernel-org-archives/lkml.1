Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYIDTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYIDTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYIDTNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:13:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbYIDTNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:13:46 -0400
Date: Thu, 4 Sep 2008 21:13:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [PATCH 5/6] x86: move mtrr cpu cap setting early in
	early_init_xxxx
Message-ID: <20080904191333.GD24990@elte.hu>
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com> <1220312246-30879-5-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220312246-30879-5-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2
> 
> root case:
> 	we move mtrr_bp_init early for mtrr trimming.
> and in early_detect, only read cap from cpuid, so some cpu doesn't have
> that bit in cpuid and need to set workaround bit will have problem.
> 
> need to add early_init_xxxx to preset those bit before mtrr_bp_init
> for those earlier cpus.
> 
> this patch is for 2.6.27

hm, not sure we can do it in v2.6.27 as it depends on the other CPU init 
patches and that is a rather sensitive codepath. This problem should be 
present in v2.6.26 too, right?

	Ingo
