Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYJGOke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYJGOke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJGOkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:40:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51864 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYJGOkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:40:11 -0400
Date: Tue, 7 Oct 2008 07:33:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Corey Minyard <minyard@acm.org>,
       David Miller <davem@davemloft.net>, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
Message-ID: <20081007143346.GA6384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <48EA9A59.1090306@acm.org> <20081007083750.GB17079@2ka.mipt.ru> <48EB6F2D.100@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EB6F2D.100@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 09:16:13AM -0500, Christoph Lameter wrote:
> Evgeniy Polyakov wrote:
> > On Mon, Oct 06, 2008 at 06:08:09PM -0500, Corey Minyard (minyard@acm.org) wrote:
> >> Would using SLAB_DESTROY_BY_RCU be ok, or would that be too expensive?
> > 
> > I tested skb destruction via RCU path, and got 2.5 times worse numbers
> > with small-packets-bulk-transfer workload.
> 
> Was this with regular RCU freeing? This will cool down the cacheline before
> frees. You need SLAB_DESTROY_BY_RCU to keep the objects cache hot.

Indeed!

But care is required -- SLAB_DESTROY_BY_RCU permits objects to be freed
and reallocated while a reader holds a reference.  The only guarantee is
that the -type- of the data structure will not change while a reader holds
a reference.  With something like UDP, this might well be sufficient.

Just be careful!  ;-)

							Thanx, Paul
