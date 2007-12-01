Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXLAGBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXLAGBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 01:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXLAGBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 01:01:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33324 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXLAGBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 01:01:01 -0500
Date: Fri, 30 Nov 2007 22:00:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, netdev@vger.kernel.org,
       bridge@lists.osdl.org, devel@openvz.org,
       shemminger@linux-foundation.org, xemul@openvz.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove rcu_assign_pointer() penalty for NULL pointers
Message-ID: <20071201060058.GA4734@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071201003721.GA22726@linux.vnet.ibm.com> <20071201010752.GA26621@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201010752.GA26621@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 12:07:52PM +1100, Herbert Xu wrote:
> On Fri, Nov 30, 2007 at 04:37:21PM -0800, Paul E. McKenney wrote:
> > 
> > The rcu_assign_pointer() primitive currently unconditionally executes
> > a memory barrier, even when a NULL pointer is being assigned.  This
> > has lead some to avoid using rcu_assign_pointer() for NULL pointers,
> > which loses the self-documenting advantages of rcu_assign_pointer()
> > This patch uses __builtin_const_p() to omit needless memory barriers
> > for NULL-pointer assignments at compile time with no runtime penalty,
> > as discussed in the following thread:
> > 
> > 	http://www.mail-archive.com/netdev@vger.kernel.org/msg54852.html
> > 
> > Tested on x86_64 and ppc64, also compiled the four cases (NULL/non-NULL
> > and const/non-const) with gcc version 4.1.2, and hand-checked the
> > assembly output.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Thanks a lot for following through with this Paul!

No problem -- after all, it is not every day that one gets the opportunity
to make a simple change that speeds things up and makes kernel hackers
lives a bit simpler.  ;-)

						Thanx, Paul
