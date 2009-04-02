Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbZDBQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbZDBQ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764689AbZDBQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:28:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57950 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764551AbZDBQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:28:13 -0400
Date: Fri, 3 Apr 2009 00:09:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402160941.GB2173@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com> <49D4B87D.2000202@redhat.com> <20090402145018.GA816@gondor.apana.org.au> <49D4D301.2090209@redhat.com> <20090402154041.GA1774@gondor.apana.org.au> <49D4E072.2060003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4E072.2060003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 06:57:38PM +0300, Avi Kivity wrote:
>
> What if the guest sends N packets, then does some expensive computation  
> (say the guest scheduler switches from the benchmark process to  
> evolution).  So now we have the marker set at packet N, but the host  
> will not see it until the guest timeslice is up?

Well that's fine.  The guest will use up the remainder of its
timeslice.  After all we only have one core/hyperthread here so
this is no different than if the packets were held up higher up
in the guest kernel and the guest decided to do some computation.

Once its timeslice completes the backend can start plugging away
at the backlog.

Of course it would be better to put the backend on another core
that shares the cache or a hyperthread on the same core.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
