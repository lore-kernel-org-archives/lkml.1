Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXJ0MuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXJ0MuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ0Mt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:49:59 -0400
Received: from ozlabs.org ([203.10.76.45]:34306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbXJ0Mt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:49:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Sat, 27 Oct 2007 22:50:15 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Matthew Wilcox" <willy@linux.intel.com>
References: <20071024195847.GE27248@parisc-linux.org> <200710261211.01423.rusty@rustcorp.com.au> <84144f020710270447m6f77848fl1f0c43312d172309@mail.gmail.com>
In-Reply-To: <84144f020710270447m6f77848fl1f0c43312d172309@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710272250.16323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 21:47:09 Pekka Enberg wrote:
> Hi Rusty,

Hi Pekka,

> On 10/26/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > How about this?  It's as simple as I could make it...
>
> FWIW I like this patch better.

Thanks.

> > +               kfree(oldsb);
> > +               *sb = (struct stringbuf *)enomem_string;
>
> Why don't we just return -ENOMEM here just like all other APIs in the
> kernel?

I think Willy did it because this is for printk.  It makes more sense than 
everyone opencoding an -ENOMEM handler, which will have to be replaced by 
some mildly amusing string like "I want to printk but I have no memory!".  
Next think you know 70% of the kernel will be bad limericks as everyone tries 
to one-up each other.

> And I wonder if it makes more sense to store gfp_flags in 
> struct stringbuf and always use that? I mean, why would you want to
> sometimes do GFP_ATOMIC and GFP_KERNEL allocations for the same
> buffer?

Firstly we don't have a buffer on first call (NULL), though we could introduce 
an sb_init() for that.  Secondly, since the purpose of this code is because 
they can't do the printk all at once: who's to say that isn't because they 
need to grab a lock for some of it?  Finally, we generally choose to expose 
the alloc flags to the caller to make them think about whether they really 
want to do allocation at this point.

Cheers,
Rusty.
