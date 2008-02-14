Return-Path: <linux-kernel-owner+w=401wt.eu-S1765503AbYBNXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503AbYBNXiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbYBNXiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:38:14 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53031 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbYBNXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:38:12 -0500
Date: Thu, 14 Feb 2008 15:37:59 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Julia Lawall <julia@diku.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
Message-ID: <20080214233759.GA30902@us.ibm.com>
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk> <84144f020802141018i235d3adfu13a84d124dc3964e@mail.gmail.com> <Pine.LNX.4.64.0802142049510.19977@ask.diku.dk> <200802142316.44985.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802142316.44985.m.kozlowski@tuxland.pl>
X-Operating-System: Linux 2.6.24-09594-g7cf712d (x86_64)
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.02.2008 [23:16:44 +0100], Mariusz Kozlowski wrote:
> Hello,
> 
> > > >  Is it just me, or does
> > > >
> > > >         ((user_addr + iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE - user_addr/PAGE_SIZE)
> > > >
> > > >  not simplify to
> > > >
> > > >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE + user_addr/PAGE_SIZE - user_addr/PAGE_SIZE)
> > > >
> > > >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE)
> > > >
> > > >         = DIV_ROUND_UP(iov[seg].iov_len, PAGE_SIZE)
> > > >
> > > >  CMIIW.
> > > 
> > > I double-checked this and I believe you're correct. It's simpler to
> > > see when you do:
> > > 
> > >   x = user_addr
> > >   y = iov[seg].iov_len
> > >   z = PAGE_SIZE
> > > 
> > > So
> > > 
> > >   (x + y + z - 1)/z - x/z
> > > 
> > >   = [x + (y + z - 1)]/z - x/z
> > > 
> > >   = [xz + z(y + z - 1)]/z^2 - x/z
> > > 
> > >   = x/z + (y + z - 1)/z - x/z
> > > 
> > > And the rest follows from your simplifications.
> > 
> > It doesn't work:
> > 
> >  ((3+4+5-1)/5) - (3/5) = 2
> >  ((4+5-1)/5) = 1
> 
> Logic was wrong but conclusion was right :) and so was Nishanth:

<snip>

As I replied to Julia off-list -- the math I and others have given is
correct, but assumes we're dealing with real-typed values. However, we
only have integer types in the kernel, meaning the divisions truncate.

Thus, while mathematically equivalent, the simplification is not
computationally so.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
