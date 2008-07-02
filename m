Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYGBIVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYGBIVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGBIVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:21:22 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:49225 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYGBIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:21:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:subject:message-id:mime-version:content-type:con
	tent-disposition:in-reply-to:user-agent;
	b=vK0z7eHreXL2FZaVThKiWB/JHuNHFyV5h1qvgcsaSJ2s2WMMmZ13KGTMG/MlC
	RCW1nTu9qoQn2NDk8G7dJdLXA==
Date: Wed, 2 Jul 2008 10:21:18 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: inux-next 0701 mv643xx_eth powerpc build failure
Message-ID: <20080702082117.GA18989@xi.wantstofly.org>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au> <20080702031111.GA26752@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702031111.GA26752@nineveh.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:11:12PM -0400, Joseph Fannin wrote:

> I'm getting a build failure on 32bit powerpc in -next, but not in mainline:
> 
> drivers/net/mv643xx_eth.c: In function 'mv643xx_eth_netpoll':
> drivers/net/mv643xx_eth.c:2115: error: 'INT_CAUSE_EXT' undeclared
> (first use in this function)
> drivers/net/mv643xx_eth.c:2115: error: (Each undeclared identifier is
> reported only once
> drivers/net/mv643xx_eth.c:2115: error: for each function it appears in.)

Does this fix it for you?


Index: linux-2.6.26-rc8/drivers/net/mv643xx_eth.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/net/mv643xx_eth.c
+++ linux-2.6.26-rc8/drivers/net/mv643xx_eth.c
@@ -2184,7 +2184,7 @@ static void mv643xx_eth_netpoll(struct n
 
 	mv643xx_eth_irq(dev->irq, dev);
 
-	wrl(mp, INT_MASK(mp->port_num), INT_TX_END | INT_RX | INT_CAUSE_EXT);
+	wrl(mp, INT_MASK(mp->port_num), INT_TX_END | INT_RX | INT_EXT);
 }
 #endif
 


> I haven't investigated any further than a quick check if this hardware
> even makes sense on 32bit powerpc -- it seems it does.

It does -- it is used on ARM, PPC and MIPS.
