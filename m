Return-Path: <linux-kernel-owner+w=401wt.eu-S1767448AbXCIRsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767448AbXCIRsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767444AbXCIRsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:48:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767448AbXCIRsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:48:03 -0500
Date: Fri, 9 Mar 2007 09:47:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <20070309090510.GA24908@infradead.org>
Message-ID: <Pine.LNX.4.64.0703090938450.10832@woody.linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain>
 <20070309065055.GA18056@pazke.donpac.ru> <20070309075308.GE8798@infradead.org>
 <20070309090218.GB18056@pazke.donpac.ru> <20070309090510.GA24908@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Christoph Hellwig wrote:
> 
> It was only put in under the premise that they'll fix whatever breaks,
> we're not going to put any maintaince border on us to hack around
> broken propritary compilers.

Well, since Rusty's macro was hoddible *anyway*, I don't think I'd apply 
it as-is. Breaking icc for something that ugly and not-very-important 
simply makes no sense.

There are better ways to do this. 

For one, you could (and should!) abstract these kinds of things out, 
rather than put them in another macro that really does something totally 
different. Then, the macro could have become

	#define ARRAY_SIZE (sizeof_expression + 0*error_if_not_array)

which would already be a hell of a lot more readable. But more 
importantly, it's also now suddenly much easiler to abstract out for 
different compilers.

We *already* support different compilers through <linux/compiler.h>, and 
there just isn't any reason for bad code just for bad codes sake!

				Linus


