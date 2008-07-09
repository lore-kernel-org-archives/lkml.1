Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYGIIoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYGIIoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYGIInv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:43:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56780 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbYGIInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:43:50 -0400
Date: Wed, 9 Jul 2008 16:43:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPSEC in 2.6.25 causes stalled connections
Message-ID: <20080709084334.GA12484@gondor.apana.org.au>
References: <20080608010858.GA8877@swan.nt.tuwien.ac.at> <E1K8TuP-0002Qd-00@gondolin.me.apana.org.au> <20080618004544.GA25439@swan.nt.tuwien.ac.at> <20080708080742.GA25027@gondor.apana.org.au> <20080708213302.GA28842@swan.nt.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708213302.GA28842@swan.nt.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 11:33:02PM +0200, Thomas Zeitlhofer wrote:
>
>    (1) Use two (virtual) machines kvm1 and kvm2 and configure an IPSEC
>        connection between them.
>    (2) Watch the interface of one machine with nload or a similar tool
>    (3) kvm1:~# cat /dev/zero | netcat -l -p 12345 &
>    (4) kvm2:~# cat /dev/zero | netcat -l -p 12345 &
>    (5) kvm1:~# netcat kvm2 12345 >/dev/null
> 
>    According to (2), the packet flow from kvm2 to kvm1 can bee watched
>    now and everything works fine.
> 
>    (6) kvm2:~# netcat kvm1 12345 >/dev/null

Thanks! I've reproduced the problem.  Now we just need to figure
out what it is :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
