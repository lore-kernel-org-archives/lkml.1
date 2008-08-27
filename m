Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYH0WHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYH0WHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYH0WGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:06:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56024 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYH0WGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:06:54 -0400
Date: Wed, 27 Aug 2008 23:06:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
Message-ID: <20080827220652.GD28946@ZenIV.linux.org.uk>
References: <adaod3ef82e.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaod3ef82e.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:43:05PM -0700, Roland Dreier wrote:
> Can anyone explain why building the current kernel gives
> 
>     drivers/net/mlx4/mcg.c: In function 'mlx4_multicast_attach':
>     drivers/net/mlx4/mcg.c:217: warning: integer overflow in expression
> 
> (with gcc (Ubuntu 4.3.1-9ubuntu1) 4.3.1 on x86-64), while the patch
> below gets rid of the warning?  I can't see what is overflowing in the
> expression that is warned out.
> 
> MGM_BLCK_LB_BIT is 30, and 1 << 30 is not negative or close to
> overflowing.  And MGM_QPN_MASK is 0x00FFFFFF, which is also nowhere near
> to integer overflow.
> 
> A fairly small test case that I don't understand either is:
> 
> unsigned foo(int x)
> {
> 	return (((x & 0xffffff) | (1 << 30)) & 0xff000000) >> 24;
> }
> 
> just running "gcc -c" (ie no extra warnings enabled) on that produces
> the same:
> 
>     b.c: In function 'foo':
>     b.c:3: warning: integer overflow in expression
> 
> I'm sure there's some promotion rule or something that makes sense of
> this, but it's a mystery to me...

There isn't.  It's gcc being buggy and inconsistent.
