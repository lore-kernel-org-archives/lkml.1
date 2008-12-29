Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYL2QxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYL2QxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYL2QxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:53:00 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:48382 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbYL2Qw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:52:59 -0500
Subject: Re: linux-next: origin tree build failure
From: Aleksey Senin <alekseys@voltaire.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "general@lists.openfabrics.org" <general@lists.openfabrics.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <adavdt3t0wf.fsf@cisco.com>
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	 <ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60>
	 <adavdt3t0wf.fsf@cisco.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Dec 2008 18:52:02 +0200
Message-Id: <1230569522.4261.44.camel@alst60>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought about this.It can be solved by loading ipv6 module before
RDMA_CM by specifying modules dependencies in modprobe.conf file. At
least this solution helps in the the case when administrator want IB,
but not IPv6.
On Mon, 2008-12-29 at 08:13 -0800, Roland Dreier wrote:
> > After another investigation of this problem, I think that proposed
>  > solution is #ifdef as good for a first stage. IPv6 support is mandatory
>  > when we are talking about running linux in some organization. But, of
>  > course, the way how it implemented in IB stack should be changed. So on
>  > the second stage, I'd like drop out these "defines" and at the time of
>  > module initialization obtain addresses of IPv6 functions and in the case
>  > if they are present at the runtime, call them. It should be nice
>  > solution for RMDA_CM and IPoIB modules.
> 
> I don't think this second stage sounds like a good idea.  Suppose
> someone loads the RDMA CM first, so it doesn't find the ipv6 functions,
> and then later loads and configures ipv6.  You'll end up in a situation
> where trying to make an IPv6 connection fails spuriously.  (And just the
> ugliness of looking up function pointers isn't very nice either)
> 
>  - R.
