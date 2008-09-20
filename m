Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbYITQCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYITQCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYITQCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:02:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15169 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYITQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:02:15 -0400
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
In-Reply-To: <20080920084512.58f7fb08@infradead.org>
References: <20080919.234824.223177211.davem@davemloft.net>
	 <1221924561.1343.121.camel@localhost.localdomain>
	 <20080920084512.58f7fb08@infradead.org>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 09:02:09 -0700
Message-Id: <1221926529.1343.140.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-20 at 08:45 -0700, Arjan van de Ven wrote:
> On Sat, 20 Sep 2008 08:29:21 -0700
> > 
> > > Jen's, as stated, has block layer uses for this.  I intend to use
> > > this for receive side flow seperation on non-multiqueue network
> > > cards.  And Steffen Klassert has a set of IPSEC parallelization
> > > changes that can very likely make use of this.
> > 
> > What's the benefit that you (or Jens) sees from migrating softirqs
> > from specific cpu's to others?
> 
> it means you do all the processing on the CPU that submitted the IO in
> the first place, and likely still has the various metadata pieces in
> its CPU cache (or at least you know you won't need to bounce them over)


In the case of networking and block I would think a lot of the softirq
activity is asserted from userspace.. Maybe the scheduler shouldn't be
migrating these tasks, or could take this softirq activity into
account ..

Daniel

