Return-Path: <linux-kernel-owner+w=401wt.eu-S938083AbXHHVhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938083AbXHHVhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbXHHVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:36:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933046AbXHHVgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:36:45 -0400
Date: Wed, 8 Aug 2007 14:31:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, andi@firstfloor.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au
Subject: Re: [patch] ipvs: force read of atomic_t in while loop
Message-Id: <20070808143115.de539511.akpm@linux-foundation.org>
In-Reply-To: <46BA30DC.20207@redhat.com>
References: <20070808093300.GA14530@osiris.boeblingen.de.ibm.com>
	<20070808.032131.35507346.davem@davemloft.net>
	<20070808102835.GC14530@osiris.boeblingen.de.ibm.com>
	<46BA30DC.20207@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 17:08:44 -0400
Chris Snook <csnook@redhat.com> wrote:

> Heiko Carstens wrote:
> > On Wed, Aug 08, 2007 at 03:21:31AM -0700, David Miller wrote:
> >> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >> Date: Wed, 8 Aug 2007 11:33:00 +0200
> >>
> >>> Just saw this while grepping for atomic_reads in a while loops.
> >>> Maybe we should re-add the volatile to atomic_t. Not sure.
> >> I think whatever the choice, it should be done consistently
> >> on every architecture.
> >>
> >> It's just asking for trouble if your arch does it differently from
> >> every other.
> > 
> > Well..currently it's i386/x86_64 and s390 which have no volatile
> > in atomic_t. And yes, of course I agree it should be consistent
> > across all architectures. But it isn't.
> 
> Based on recent discussion, it's pretty clear that there's a lot of 
> confusion about this.  A lot of people (myself included, until I thought 
> about it long and hard) will reasonably assume that calling 
> atomic_read() will actually read the value from memory.  Leaving out the 
> volatile declaration seems like a pessimization to me.  If you force 
> people to use barrier() everywhere they're working with atomic_t, it 
> will force re-reads of all the non-atomic data in use as well, which 
> will cause more memory fetches of things that generally don't need 
> barrier().  That and it's a bug waiting to happen.
> 
> Andi -- your thoughts on the matter?

I'm not Andi, but this not-Andi thinks that permitting the compiler to cache
the results of atomic_read() is dumb.

