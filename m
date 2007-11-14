Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXKNL7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXKNL7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXKNL65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:58:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51546
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbXKNL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:58:56 -0500
Date: Wed, 14 Nov 2007 03:58:50 -0800 (PST)
Message-Id: <20071114.035850.202836100.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711141049.49154.nickpiggin@yahoo.com.au>
References: <20071114.031216.11725447.davem@davemloft.net>
	<18234.57272.590960.860941@cargo.ozlabs.ibm.com>
	<200711141049.49154.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 14 Nov 2007 10:49:48 +1100

> On Wednesday 14 November 2007 22:44, Paul Mackerras wrote:
> > David Miller writes:
> > > This is my impression too, all of the things being done with
> > > a slew of system calls would be better served by real special
> > > files and appropriate fops.
> >
> > Special files and fops really only work well if you can coerce the
> > interface into one where data flows predominantly one way.  I don't
> > think they work so well for something that is more like an RPC across
> > the user/kernel barrier.  For that a system call is better.
> >
> > For instance, if you have something that kind-of looks like
> >
> > 	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);
> >
> > where the caller supplies an array of PMD numbers and the function
> > returns their values (and you want that reading to be done atomically
> > in some sense), how would you do that using special files and fops?
> 
> Could you implement it with readv()?

Sure, why not?  Just cook up an iovec.  pmd_numbers goes to offset
X and pmd_values goes to offset Y, with some helpers like what
we have in the networking already for recvmsg.

But why would you want readv() for this?  The syscall thing
Paul asked me to translate into a read() doesn't provide
iovec-like behavior so I don't see why readv() is necessary
at all.
