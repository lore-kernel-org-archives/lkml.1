Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbXJ0Qe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbXJ0Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbXJ0Qet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:34:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:4388 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbXJ0Qes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Qx3T7l/2+9E94VshFKQnialM+d8rWa7V/Gbrz2yx1vc/DBVAAwTzbTcLywW76kHBOtk7eBv3MDYhD+g4+d8BqYhlIMFf8z7mMAdALOX3fR9iu0v6acYZuew+XnbADeTv1q/OqvaTNo/kLWPkx4zbAoswsF6fUQF6X1fumH0c6UI=
Message-ID: <84144f020710270934j54153c8bibb2d1fb48abd8dca@mail.gmail.com>
Date: Sat, 27 Oct 2007 19:34:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Matthew Wilcox" <willy@linux.intel.com>
In-Reply-To: <200710272250.16323.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024195847.GE27248@parisc-linux.org>
	 <200710261211.01423.rusty@rustcorp.com.au>
	 <84144f020710270447m6f77848fl1f0c43312d172309@mail.gmail.com>
	 <200710272250.16323.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 5c713c021abebafe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Saturday 27 October 2007 21:47:09 Pekka Enberg wrote:
> > > +               kfree(oldsb);
> > > +               *sb = (struct stringbuf *)enomem_string;
> >
> > Why don't we just return -ENOMEM here just like all other APIs in the
> > kernel?

On 10/27/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> I think Willy did it because this is for printk.  It makes more sense than
> everyone opencoding an -ENOMEM handler, which will have to be replaced by
> some mildly amusing string like "I want to printk but I have no memory!".
> Next think you know 70% of the kernel will be bad limericks as everyone tries
> to one-up each other.

My point was, of course, that the caller gets to decide what to do on
OOM. For the most part, you probably want to ignore it but for things
like pseudo filesystems where you generate a human-readable string,
returning -ENOMEM from read(2) is preferable.

On Saturday 27 October 2007 21:47:09 Pekka Enberg wrote:
> > And I wonder if it makes more sense to store gfp_flags in
> > struct stringbuf and always use that? I mean, why would you want to
> > sometimes do GFP_ATOMIC and GFP_KERNEL allocations for the same
> > buffer?

On 10/27/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Firstly we don't have a buffer on first call (NULL), though we could introduce
> an sb_init() for that.  Secondly, since the purpose of this code is because
> they can't do the printk all at once: who's to say that isn't because they
> need to grab a lock for some of it?  Finally, we generally choose to expose
> the alloc flags to the caller to make them think about whether they really
> want to do allocation at this point.

Yeah, makes sense. Thanks.

                                   Pekka
