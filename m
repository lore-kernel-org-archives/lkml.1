Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbYBNTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbYBNTu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYBNTur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:50:47 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52255 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYBNTuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:50:46 -0500
Date: Thu, 14 Feb 2008 20:50:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
In-Reply-To: <84144f020802141018i235d3adfu13a84d124dc3964e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802142049510.19977@ask.diku.dk>
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk> 
 <20080214173850.GC14191@us.ibm.com> <84144f020802141018i235d3adfu13a84d124dc3964e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Pekka Enberg wrote:

> Hi Nishanth,
> 
> On Thu, Feb 14, 2008 at 7:38 PM, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> >  Is it just me, or does
> >
> >         ((user_addr + iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE - user_addr/PAGE_SIZE)
> >
> >  not simplify to
> >
> >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE + user_addr/PAGE_SIZE - user_addr/PAGE_SIZE)
> >
> >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE)
> >
> >         = DIV_ROUND_UP(iov[seg].iov_len, PAGE_SIZE)
> >
> >  CMIIW.
> 
> I double-checked this and I believe you're correct. It's simpler to
> see when you do:
> 
>   x = user_addr
>   y = iov[seg].iov_len
>   z = PAGE_SIZE
> 
> So
> 
>   (x + y + z - 1)/z - x/z
> 
>   = [x + (y + z - 1)]/z - x/z
> 
>   = [xz + z(y + z - 1)]/z^2 - x/z
> 
>   = x/z + (y + z - 1)/z - x/z
> 
> And the rest follows from your simplifications.

It doesn't work:

 ((3+4+5-1)/5) - (3/5) = 2
 ((4+5-1)/5) = 1

julia

