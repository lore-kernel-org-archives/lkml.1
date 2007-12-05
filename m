Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbXLEJ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbXLEJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLEJz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:55:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbXLEJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:55:58 -0500
Date: Wed, 05 Dec 2007 01:55:58 -0800 (PST)
Message-Id: <20071205.015558.224988608.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: simon@fire.lp0.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071205073927.GA12413@gondor.apana.org.au>
References: <20071205071607.GA11852@gondor.apana.org.au>
	<20071204.233432.136250076.davem@davemloft.net>
	<20071205073927.GA12413@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 5 Dec 2007 18:39:27 +1100

> On Tue, Dec 04, 2007 at 11:34:32PM -0800, David Miller wrote:
> > 
> > TCP has some built-in assumptions about characteristics of
> > interent links and what constitutes a timeout which is "too long"
> > and should thus result in a full connection failure.
> > 
> > IPSEC changes this because of IPSEC route resolution via
> > ISAKMP.
> > 
> > With this in mind I can definitely see people preferring
> > the "block until IPSEC resolves" behavior, especially for
> > something like, say, periodic remote backups and stuff like
> > that where you really want the thing to just sit and wait
> > for the connect() to succeed instead of failing.
> 
> Hmm, but connect(2) should succeed in that case thanks to the
> blackhole route, no? The subsequent SYNs will then be dropped
> until the IPsec SAs are in place.

If it hits sysctl_tcp_syn_retries SYN attempts, the connect will hard
fail.

