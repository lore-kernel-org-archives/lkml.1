Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbZCXP75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbZCXP75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZCXP7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:59:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42223 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751729AbZCXP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:59:47 -0400
Date: Tue, 24 Mar 2009 23:59:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324155911.GA30824@gondor.apana.org.au>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324153616.GA31143@elte.hu> <20090324154717.GA7506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324154717.GA7506@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:47:17PM +0100, Ingo Molnar wrote:
> 
> test failure on one of the boxes, interface got stuck after ~100K 
> packets:
> 
> eth1      Link encap:Ethernet  HWaddr 00:13:D4:DC:41:12  
>           inet addr:10.0.1.13  Bcast:10.0.1.255  Mask:255.255.255.0
>           inet6 addr: fe80::213:d4ff:fedc:4112/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:22555 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:1897 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000 
>           RX bytes:2435071 (2.3 MiB)  TX bytes:503790 (491.9 KiB)
>           Interrupt:11 Base address:0x4000 

What's the NIC and config on this one? If it's still using the
legacy/netif_rx path, where GRO is off by default, this patch
should make it exactly the same as with my original patch reverted.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
