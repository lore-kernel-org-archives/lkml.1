Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbXCJUgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbXCJUgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbXCJUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:36:44 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43443 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbXCJUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:36:43 -0500
Date: Sat, 10 Mar 2007 12:36:41 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <Pine.LNX.4.64.0703090938450.10832@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0703101229090.15510@shell4.speakeasy.net>
References: <1173419792.32234.131.camel@localhost.localdomain>
 <20070309065055.GA18056@pazke.donpac.ru> <20070309075308.GE8798@infradead.org>
 <20070309090218.GB18056@pazke.donpac.ru> <20070309090510.GA24908@infradead.org>
 <Pine.LNX.4.64.0703090938450.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Linus Torvalds wrote:
> On Fri, 9 Mar 2007, Christoph Hellwig wrote:
> Well, since Rusty's macro was hoddible *anyway*, I don't think I'd apply
> it as-is. Breaking icc for something that ugly and not-very-important
> simply makes no sense.
>
> There are better ways to do this.
>
> For one, you could (and should!) abstract these kinds of things out,
> rather than put them in another macro that really does something totally
> different. Then, the macro could have become
>
> 	#define ARRAY_SIZE (sizeof_expression + 0*error_if_not_array)

/* Error if X is a pointer, 0 otherwise */
#define ERROR_IF_POINTER(x) \
	sizeof(int[-__builtin_types_compatible_p(typeof(x), typeof(&x[0]))])

/* Warning (div by zero) if x is a pointer, 0 otherwise */
#define WARN_IF_POINTER(x) \
	(0/!__builtin_types_compatible_p(typeof(x), typeof(&x[0])))

The gcc docs say __builtin_types_compatible_p returns 1 or 0, so the !!
isn't necessary.  And my gcc at least returns 0 for sizeof(int[0]).
