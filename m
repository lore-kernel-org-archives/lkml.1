Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYDSKmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYDSKmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDSKmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:42:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYDSKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:42:07 -0400
Date: Sat, 19 Apr 2008 12:41:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
	latest -git
Message-ID: <20080419104152.GB13599@elte.hu>
References: <20080419100034.GA9475@elte.hu> <20080419.030736.168169087.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419.030736.168169087.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 19 Apr 2008 12:00:35 +0200
> 
> [ netfilter-devel and netdev added to CC: ]
> 
> > randconfig testing found a netfilter build failure in latest -git:
> > 
> >   net/netfilter/nf_conntrack_sip.c: In function 'set_expected_rtp_rtcp':
> >   net/netfilter/nf_conntrack_sip.c:786: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
> > 
> >   http://redhat.com/~mingo/misc/config-Sat_Apr_19_11_37_02_CEST_2008.bad
> > 
> > disabling CONFIG_NF_CONNTRACK_SIP works it around.
> 
> I think this will fix it.
> 
> Patrick, is this how we should do it?
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index c1fc0f1..fd60b2b 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -245,7 +245,7 @@ config NF_CONNTRACK_SANE
>  
>  config NF_CONNTRACK_SIP
>  	tristate "SIP protocol support"
> -	depends on NF_CONNTRACK
> +	depends on NF_CONNTRACK && NF_NAT
>  	default m if NETFILTER_ADVANCED=n
>  	help
>  	  SIP is an application-layer control protocol that can establish,

thanks David, this solves the build failure here.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo

