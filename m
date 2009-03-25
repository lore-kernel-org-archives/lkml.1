Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZCYAYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZCYAYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZCYAXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:23:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59027 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011AbZCYAXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:23:51 -0400
Date: Wed, 25 Mar 2009 08:23:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325002303.GA2219@gondor.apana.org.au>
References: <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324.143622.186562202.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:36:22PM -0700, David Miller wrote:
>
> I think the problem is that we need to do the GRO flush before the
> list delete and clearing the NAPI_STATE_SCHED bit.

Well first of all GRO shouldn't even be on in Ingo's case, unless
he enabled it by hand with ethtool.  Secondly the only thing that
touches the GRO state for the legacy path is process_backlog, and
since this is per-cpu, I can't see how another instance can run
while the first is still going.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
