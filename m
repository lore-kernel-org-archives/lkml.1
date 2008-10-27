Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbYJ0Jm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbYJ0Jm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYJ0JmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:42:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYJ0JmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:42:14 -0400
Date: Mon, 27 Oct 2008 10:41:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.28-rc2] i386: fix forbid_dac linkage error when
	CONFIG_PCI=n
Message-ID: <20081027094157.GB4278@elte.hu>
References: <200810270817.m9R8HsJu029399@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810270817.m9R8HsJu029399@harpo.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Fix 2.6.28-rc2 build failure on i386 with CONFIG_PCI=n:

> +#ifdef CONFIG_PCI
>  		if (!strncmp(p, "allowdac", 8))
>  			forbid_dac = 0;
>  		if (!strncmp(p, "nodac", 5))
> @@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
>  			forbid_dac = -1;
>  			return 1;
>  		}
> +#endif /* CONFIG_PCI */

there's a better fix for this queued up in the PCI tree, see:

 http://marc.info/?l=linux-kernel&m=122480590627590&w=2

	Ingo
