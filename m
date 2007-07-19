Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbXGST5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbXGST5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXGST5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:57:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbXGST5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:57:02 -0400
Date: Thu, 19 Jul 2007 21:56:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719195650.GA2136@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707192113.26878.olaf.kirch@oracle.com> <20070719192256.GA22151@elte.hu> <200707192135.43652.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707192135.43652.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> Does the following help?

> --- build-2.6.orig/drivers/net/netconsole.c
> +++ build-2.6/drivers/net/netconsole.c
> @@ -70,7 +70,7 @@ static void write_msg(struct console *co
>  	int frag, left;
>  	unsigned long flags;
>  
> -	if (!np.dev)
> +	if (!np.dev || !netif_running(np.dev))
>  		return;

nope - with this patch applied the box still has no network, symptoms 
are similar. (should i apply the WARN_ON() patch too?)

	Ingo
