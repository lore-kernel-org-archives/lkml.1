Return-Path: <linux-kernel-owner+w=401wt.eu-S2993054AbXEBMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993054AbXEBMeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXEBMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:34:17 -0400
Received: from ozlabs.org ([203.10.76.45]:56969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993054AbXEBMeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:34:16 -0400
Subject: Re: Race between RCU and rmmod
From: Rusty Russell <rusty@rustcorp.com.au>
To: dipankar@in.ibm.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070502120051.GA13349@in.ibm.com>
References: <30958.1178106624@redhat.com>
	 <20070502120051.GA13349@in.ibm.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 22:33:40 +1000
Message-Id: <1178109221.28659.312.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 17:30 +0530, Dipankar Sarma wrote:
> On Wed, May 02, 2007 at 12:50:24PM +0100, David Howells wrote:
> > 
> > Hi Dipankar, Rusty,
> > 
> > I seem to have found a race between RCU and rmmod.  What I see appears to be
> > an RCU destructor function that has a call pending but lives in a module, gets
> > deleted before the RCU callback is processed:
> > 
> > RIP: 0010:[<ffffffff880329b7>]  [<ffffffff880329b7>]
> > 
> > I think that rmmod needs to clear the RCU destructor queue, probably inside of
> > __try_stop_module().
> 
> This is why we have rcu_barrier() although the corresponding documentation
> patch seems to have got dropped. Modules that use RCU must call
> rcu_barrier() in their cleanup routine.

Hi David, Dipankar,

	My first thought was wondering if doing it for them isn't a bad thing,
but they need to do it if they've got other teardown which would mess up
RCU callbacks anyway...

Cheers,
Rusty.


