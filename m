Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbXLABIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbXLABIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXLABIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:08:00 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2950 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753620AbXLABH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:07:59 -0500
Date: Sat, 1 Dec 2007 12:07:52 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, netdev@vger.kernel.org,
       bridge@lists.osdl.org, devel@openvz.org,
       shemminger@linux-foundation.org, xemul@openvz.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove rcu_assign_pointer() penalty for NULL pointers
Message-ID: <20071201010752.GA26621@gondor.apana.org.au>
References: <20071201003721.GA22726@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201003721.GA22726@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:37:21PM -0800, Paul E. McKenney wrote:
> 
> The rcu_assign_pointer() primitive currently unconditionally executes
> a memory barrier, even when a NULL pointer is being assigned.  This
> has lead some to avoid using rcu_assign_pointer() for NULL pointers,
> which loses the self-documenting advantages of rcu_assign_pointer()
> This patch uses __builtin_const_p() to omit needless memory barriers
> for NULL-pointer assignments at compile time with no runtime penalty,
> as discussed in the following thread:
> 
> 	http://www.mail-archive.com/netdev@vger.kernel.org/msg54852.html
> 
> Tested on x86_64 and ppc64, also compiled the four cases (NULL/non-NULL
> and const/non-const) with gcc version 4.1.2, and hand-checked the
> assembly output.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks a lot for following through with this Paul!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
