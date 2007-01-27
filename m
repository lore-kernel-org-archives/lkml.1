Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbXA0DKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbXA0DKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 22:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXA0DKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 22:10:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbXA0DKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 22:10:46 -0500
Date: Fri, 26 Jan 2007 19:10:45 -0800 (PST)
Message-Id: <20070126.191045.48529536.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, deweerdt@free.fr,
       netdev@vger.kernel.org, frederik.deweerdt@gmail.com,
       shemminger@osdl.org
Subject: Re: + oops-in-drivers-net-shaperc.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HAbgn-00039h-00@gondolin.me.apana.org.au>
References: <20070125.193128.39155864.davem@davemloft.net>
	<E1HAbgn-00039h-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 27 Jan 2007 11:45:05 +1100

> David Miller <davem@davemloft.net> wrote:
> > 
> > Shaper is actually OK.  None of these hardware header callbacks
> > should be invoked if the device is down.  Yet, this is what is
> > accidently being allowed in the AF_PACKET socket layer.
> 
> Hmm, what if the device goes down after the check?

For the shaper case it's OK, because once a shaper is
associated it's ->dev never goes back to NULL.

In general, yes it's a problem :-/
