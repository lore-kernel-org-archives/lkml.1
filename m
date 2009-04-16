Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZDPJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZDPJW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZDPJWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:22:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZDPJWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:22:46 -0400
Date: Thu, 16 Apr 2009 11:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] irq: make ht irq_desc numa aware
Message-ID: <20090416092137.GK9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68D7F.7060209@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E68D7F.7060209@kernel.org>
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

> Impact: use create_irq_nr
> 
> try to get irq_desc on the node with create_irq_nr
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/htirq.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/htirq.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/htirq.c
> +++ linux-2.6/drivers/pci/htirq.c
> @@ -98,6 +98,7 @@ int __ht_create_irq(struct pci_dev *dev,
>  	int max_irq;
>  	int pos;
>  	int irq;
> +	int node;
>  
>  	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
>  	if (!pos)
> @@ -125,7 +126,8 @@ int __ht_create_irq(struct pci_dev *dev,
>  	cfg->msg.address_lo = 0xffffffff;
>  	cfg->msg.address_hi = 0xffffffff;
>  
> -	irq = create_irq();
> +	node = dev_to_node(&dev->dev);
> +	irq = create_irq_nr(0, node);
>  
>  	if (irq <= 0) {
>  		kfree(cfg);

this too looks nice.

The whole series has become very reasonable (modulo the minor 
structure and Cc: related comments i made).

It's obviously too late in .30 to push it upstream, so the best 
action is to mark it broken upstream, then remove + rewrite it in 
the IRQ tree and we'll have all this done properly in v2.6.31.

Thomas, Eric, Suresh, what do you think?

	Ingo
