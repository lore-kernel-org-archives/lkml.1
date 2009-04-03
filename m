Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbZDCLfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbZDCLfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbZDCLfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:35:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42136 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762985AbZDCLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:35:07 -0400
Date: Fri, 3 Apr 2009 19:34:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Avi Kivity <avi@redhat.com>,
       ghaskins@novell.com, anthony@codemonkey.ws,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090403113450.GA10352@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com> <20090403111854.GA11935@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403111854.GA11935@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:18:54PM +0200, Andi Kleen wrote:
> > Check shared ring status when stuffing a request.  If there are requests
> 
> That means you're bouncing cache lines all the time. Probably not a big
> issue on single socket but could be on larger systems.

If the backend is running on a core that doesn't share caches
with the guest queue then you've got bigger problems.

Right this is unavoidable for guests with many CPUs but that
should go away once we support multiqueue in virtio-net.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
