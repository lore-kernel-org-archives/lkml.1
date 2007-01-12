Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXBLVVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXBLVVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXBLVVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:21:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:34483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXBLVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=SSXUENL1zxvVg6yIvZLlUe69CiWPYHG0Y98hT+g/GrKYTpEoUhxWmU0wF/hg1m5eQghK9S/WwKUWUaXJPGLoGQXzI+hpMvBvztMnTLiIavqNBBRGz4CbqIvfnptOcWfdFkSIL78XjNUlz6DZYB4QhxpPf+0259BMWZsf70YLT8A=
Date: Fri, 12 Jan 2007 23:19:25 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       arjan@infradead.org
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070112231925.GA7273@slug>
References: <fa.7Z67qjqJwFP7+8QiVtu5tq6CZyU@ifi.uio.no> <fa.4Y/nCUol/tGEodoOl/Jm9nf2AEA@ifi.uio.no> <fa.TgZy4z2lRhwhAWCUE8IuGvMVUCU@ifi.uio.no> <fa.HINMjdGzCuxlEiWtVvmNz7Pv9Pc@ifi.uio.no> <fa.2ClW7C4ZyCP9QlT4vg7CbzjSqwg@ifi.uio.no> <45CDFB30.5090102@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CDFB30.5090102@shaw.ca>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 11:04:48AM -0600, Robert Hancock wrote:
> Frederik Deweerdt wrote:
> >>How about this one instead then:
> >Well, the warning you get is not that obvious:
> >test.c: In function 'main':
> >test.c:11: warning: 'deprecated_irqf' is deprecated
> >And as far as I could test 
... which apparently was not enough :)
> >(gcc 4.1.1 and gcc 3.4.3), Arjan's comment is
> >not true, the "static const int" don't use extra space, they get
> >optimized away by the compiler (see http://lkml.org/lkml/2007/2/9/106).
> 
> gcc 3.2 should be tested as well, that is still supported by the kernel, and versions before 3.4 did not have unit-at-a-time optimizations.
Sorry for the delay. I've setup a 3.2.3 gcc and, indeed, the symbols
make their way in the binary...

$ gcc-3.2.3 -O2 -c dont_use_flag.c
$ nm dont_use_flag.o
00000000 r SA_INTERRUPT
00000000 T main
         U printf

Regards,
Frederik
