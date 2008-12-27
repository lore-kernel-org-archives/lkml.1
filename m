Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYL0ImP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYL0ImP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 03:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYL0Il7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 03:41:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYL0Il6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 03:41:58 -0500
Date: Sat, 27 Dec 2008 09:41:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       venkatesh.pallipadi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: fix hang with !SPARSE_IRQ
Message-ID: <20081227084140.GA10687@elte.hu>
References: <20081225020853.GI26490@linux-os.sc.intel.com> <4955CD57.8050702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4955CD57.8050702@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix hang
> 
> Suresh report his two sockets system only works with SPARSE_IRQ enable
> it turns out we miss the setting desc->irq
> 
> so provide early_irq_init() even !SPARSE_IRQ to set desc->irq
> 
> Reported by: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  init/main.c         |    6 ------
>  kernel/irq/handle.c |   15 +++++++++++++++
>  2 files changed, 15 insertions(+), 6 deletions(-)

applied to tip/irq/sparseirq - thanks Yinghai. This fixed a testsystem of 
mine as well that showed weird hangs with !sparseirq.

	Ingo
