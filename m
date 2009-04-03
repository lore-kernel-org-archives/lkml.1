Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbZDCLtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbZDCLtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbZDCLss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:48:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47231 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762074AbZDCLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:48:46 -0400
Date: Fri, 3 Apr 2009 19:48:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, ghaskins@novell.com,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090403114828.GA10465@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com> <49D5ED11.2000800@redhat.com> <20090403111242.GA10200@gondor.apana.org.au> <49D5F6FC.5090401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5F6FC.5090401@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:46:04PM +0300, Avi Kivity wrote:
>
> The host writes the packet to tap, at which point it is consumed from  
> its point of view.  The host would like to mention that if there was an  
> API to notify it when the packet was actually consumed, then it would  
> gladly use it.  Bonus points if this involves not copying the packet.

We're using write(2) for this, no? That should invoke netif_rx_ni
which blocks until the packet is "processed", which usually means
that it's placed on the NIC's hardware queue.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
