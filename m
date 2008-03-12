Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYCLUAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYCLUAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYCLUAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:00:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYCLUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:00:45 -0400
Date: Wed, 12 Mar 2008 12:59:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, bcrl@kvack.org, linux-aio@kvack.org
Subject: Re: [PATCH] aio_write should tell userspace about partial writes
In-Reply-To: <200803120939.59915.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0803121255400.3557@woody.linux-foundation.org>
References: <200803120939.59915.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Rusty Russell wrote:
>
> [ Linus, please apply.  This patch was discussed and acked before,
>   but somehow got lost. ]

Rusty, please *look* at your patches.

It's pretty obvious even from just the patch that the patch has already 
been applied, and that the only reason you think it hasn't is that you use 
some crap-for-brains SCM model where you apply patches with GNU patch and 
allow fuzz, so it applied cleanly *again*.

I assume that it's quilt messing up again.

In particular, this already went in as commit 
7adfa2ff3efa02a7a9f2632d2d2662d3e5eb5304, and I know for a *fact* that it 
is in your tree too, since the patch itself clearly has that code double:

>  	    && iocb->ki_nbytes - iocb->ki_left)
>  		ret = iocb->ki_nbytes - iocb->ki_left;

Lookie above: those two lines are part of the thing that already got 
applied! If it hadn't been applied, it would look like

        if ((ret == 0) || (iocb->ki_left == 0))
                ret = iocb->ki_nbytes - iocb->ki_left;

instead.

I *hate* people who "merge" using patches, and then to make it even worse 
use a non-zero fuzz factor.

		Linus
