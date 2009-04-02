Return-Path: <linux-kernel-owner+w=401wt.eu-S1766000AbZDBRSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766000AbZDBRSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbZDBRRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:17:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765414AbZDBRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:17:46 -0400
Date: Fri, 3 Apr 2009 01:17:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402171727.GA3127@gondor.apana.org.au>
References: <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com> <49D4B87D.2000202@redhat.com> <20090402145018.GA816@gondor.apana.org.au> <49D4D301.2090209@redhat.com> <20090402154041.GA1774@gondor.apana.org.au> <49D4E072.2060003@redhat.com> <20090402160941.GB2173@gondor.apana.org.au> <49D4EDBD.3050900@redhat.com> <20090402170610.GA3001@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402170610.GA3001@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:06:10AM +0800, Herbert Xu wrote:
>
> That only happens if the guest immediately does some CPU-intensive
> computation 3ms and assuming its timeslice lasts that long.
> 
> In any case, the same thing will happen right now if the host or
> some other guest on the same CPU hogs the CPU for 3ms.

Even better, look at the packet's TOS.  If it's marked for low-
latency then vmexit immediately.  Otherwise continue.

In the backend you'd just set the marker in shared memory.

Of course invert this for the host => guest direction.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
