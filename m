Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbZDBPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbZDBPBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbZDBO53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760680AbZDBO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:27 -0400
Date: Thu, 2 Apr 2009 22:50:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402145018.GA816@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com> <49D4B87D.2000202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4B87D.2000202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 04:07:09PM +0300, Avi Kivity wrote:
>
> I think Rusty did mean a UP guest, and without schedule-and-forget.

Going off on a tangent here, I don't really think it should matter
whether we're UP or SMP.  The ideal state is where we have the
same number of (virtual) TX queues as there are cores in the guest.
On the host side we need the backend to run at least on a core
that shares cache with the corresponding guest queue/core.  If
that happens to be the same core as the guest core then it should
work as well.

IOW we should optimise it as if the host were UP.

> The problem is that we already have virtio guest drivers going several  
> kernel versions back, as well as Windows drivers.  We can't keep  
> changing the infrastructure under people's feet.

Yes I agree that changing the guest-side driver is a no-no.  However,
we should be able to achieve what's shown here without modifying the
guest-side.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
