Return-Path: <linux-kernel-owner+w=401wt.eu-S966602AbXEGU3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966602AbXEGU3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966592AbXEGU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:29:04 -0400
Received: from gw.goop.org ([64.81.55.164]:37706 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966593AbXEGU3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:29:03 -0400
Message-ID: <463F8C22.40902@goop.org>
Date: Mon, 07 May 2007 13:29:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] deflate inflate_dynamic too
References: <4632AF57.1070102@goop.org> <463F712F.90902@zytor.com>
In-Reply-To: <463F712F.90902@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> It might be worth reverting some of the code back to the zlib original.
>  The use of stack allocations here is actually a Linux divergence from
> zlib (done by Linus), in order to reduce the number of dynamic allocations.
>
> In general, the use of dynamic allocations is highly dangerous, because
> any time you have dynamic allocations you have the choice of either
> sleeping or failing, unless you have a pre-reserved memory pool.
>   

Well, every time this code is instantiated, it gets its own malloc/free
definitions, so they can decide how to handle the dynamic allocations. 
Seems better than assuming that every caller will have enough stack
space.  If you want to approximate that, it would be easy enough to have
a stack-like malloc/free, in which freeing the last allocation will
always release space.

    J
