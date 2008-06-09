Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbYFIVFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbYFIVFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYFIVFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:05:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbYFIVFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:05:25 -0400
Date: Mon, 9 Jun 2008 14:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: dada1@cosmosbay.com, kosaki.motohiro@jp.fujitsu.com,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
Message-Id: <20080609140503.83985d10.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806090715020.29723@schroedinger.engr.sgi.com>
References: <48439916.2070108@cosmosbay.com>
	<20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<4844BC75.8040705@cosmosbay.com>
	<20080603144054.973284bb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806090715020.29723@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 07:16:48 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 3 Jun 2008, Andrew Morton wrote:
> 
> > > +	if (NUMA_BUILD) {
> > > +		unsigned int *counters, nr;
> > > +
> > > +		counters = kzalloc(nr_node_ids * sizeof(unsigned int),
> > 
> > This is kcalloc().  If you like that sorts of thing - I think kcalloc()
> > is pretty pointless personally.
> 
> Same here. I think its generally ignored. I tried to remove it at some 
> point in the past. If we want kcalloc then we also need kczalloc.

kcalloc() zeroes the returned memory - it's like calloc().

> It would 
> be best to keep the interface simple.

yup.  Oh well, it's not a big deal.

Except the inlined

        if (n != 0 && size > ULONG_MAX / n)
                return NULL;

is a bit bloaty/inefficient.  I expect that it's often the case that
one of `n' and `size' is not a compile-time constant.

otoh, there's one good thing about kcalloc: it actually checks for
multiplicative overflows, whereas the open-coded version often forgets
to do that.

