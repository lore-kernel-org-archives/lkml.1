Return-Path: <linux-kernel-owner+w=401wt.eu-S936699AbXFGUeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936699AbXFGUeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765276AbXFGUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:34:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:19717 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763320AbXFGUeN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LELkp5DFG4KYqQrc2camc7ZdhlUz1p816bmgYIMD94ybqXyqPpeicAef9mDtFeBHIMKtIDCIBzpciYznKAKajQhlITB0QvXQ5edIk3KurSzF131jLNb1lG+oBMQ2A2i3oqmIRcLl6f6UPFtgelhfz9H3LR4Zj8IuytBki6wRSbU=
Message-ID: <6934efce0706071334w54eea3d9mfed1670f527ff831@mail.gmail.com>
Date: Thu, 7 Jun 2007 13:34:12 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, carsteno@de.ibm.com,
       "Jared Hulbert" <jaredeh@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070607193844.GB17144@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4653F264.1030807@de.ibm.com>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com>
	 <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com>
	 <20070607193844.GB17144@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jun 07, 2007 at 07:07:54PM +0200, Carsten Otte wrote:
> > I've had a few beer long discussion with Joern Engel and David
> > Woodhouse on this one. To cut a long discussion short: the current XIP
> > infrastructure is not sufficient to be used on top of mtd. We'd need
> > some extenstions:
> > - on get_xip_page() we'd need to state if we want the reference
> > read-only or read+write
> > - we need a put_xip_page() to return references
> > - and finally we need a callback for the referece, so that the mtd
> > driver can ask to get its reference back (in order to unmap from
> > userland when erasing a block)
>
> And we'll need that even when using cramfs.  There's not way we'd
> merge a hack where the user has to specify a physical address on
> the mount command line.

Why not?  For the use case in question the user usually manually
burned the image to a physical address before hand.  Many of these
system don't have MTD turned on for this Flash, they don't need it
because they don't write to this Flash once the system is up.
