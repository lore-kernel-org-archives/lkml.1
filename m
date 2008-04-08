Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYDHCEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYDHCEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYDHCEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:04:38 -0400
Received: from ozlabs.org ([203.10.76.45]:36579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbYDHCEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:04:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 4/5] tun: vringfd xmit support.
Date: Tue, 8 Apr 2008 11:51:43 +1000
User-Agent: KMail/1.9.9
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       maxk@qualcomm.com
References: <E1Jijfs-0004Lo-00@gondolin.me.apana.org.au> <200804071724.51781.rusty@rustcorp.com.au> <20080407.003528.96136816.davem@davemloft.net>
In-Reply-To: <20080407.003528.96136816.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081151.43599.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008 17:35:28 David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Mon, 7 Apr 2008 17:24:51 +1000
>
> > On Monday 07 April 2008 15:13:44 Herbert Xu wrote:
> > > On second thought, this is not going to work.  The network stack
> > > can clone individual pages out of this skb and put it into a new
> > > skb.  Therefore whatever scheme we come up with will either need
> > > to be page-based, or add a flag to tell the network stack that it
> > > can't clone those pages.
> >
> > Erk... I'll put in the latter for now.   A page-level solution is not
> > really an option: if userspace hands us mmaped pages for example.
>
> Keep in mind that the core of the TCP stack really depends
> upon being able to slice and dice paged SKBs as is pleases
> in order to send packets out.
>
> In fact, it also does such splitting during SACK processing.
>
> It really is a base requirement for efficient TSO support.
> Otherwise the above operations would be so incredibly
> expensive we might as well rip all of the TSO support out.

In this case that's OK; these are only for packets coming from 
userspace/guest, so the only interaction with the tcp code is possibly as a 
recipient.

If tcp wanted to do zero-copy aio xmit, I think we'd need something else.

Cheers,
Rusty.




