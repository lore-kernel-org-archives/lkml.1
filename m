Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXJUMRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXJUMRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXJUMRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:17:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:8503 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXJUMRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NekCUqIg6+VSzoWhajB2uoReH63cqrEfkfxVq17yG2uZj4v8FqRDyIEcxRbWZg/VEnWf03y/x644rRmq+nVUCcPiw33ArAkm7OQ3atQ2UYIm5a7B6IJXOjpKj0zAV79ZUs9bCeeNChjTjuEMvtycjh5K9r9+srqhI2CyjlrEHv8=
Message-ID: <21d7e9970710210517y585bf5a2lda34f0ae2d8b6183@mail.gmail.com>
Date: Sun, 21 Oct 2007 22:17:45 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "David Chinner" <dgc@sgi.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mark Williamson" <mark.williamson@cl.cam.ac.uk>,
       "=?ISO-8859-1?Q?Morten_B=C3=B8geskov?=" 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
In-Reply-To: <20071015125407.GA13329@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470FA7C3.90404@goop.org>
	 <200710160056.47458.nickpiggin@yahoo.com.au>
	 <20071015110735.GA11748@one.firstfloor.org>
	 <200710152128.10900.nickpiggin@yahoo.com.au>
	 <20071015125407.GA13329@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Andi Kleen <andi@firstfloor.org> wrote:
> > Hmm, OK. It looks like DRM vmallocs memory (which gives highmem).
>
> I meant I'm not sure if it uses that memory uncached. I admit
> not quite understanding that code. There used to be at least
> one place where it set UC for an user mapping though.

Currently the only DRM memory handed to userspace is vmalloc_32 in drm_scatter.c

I notice the VIA driver does its own vmalloc for dmablit, so it may
have an issue with this if highmem is involved.

This will change with the upcoming memory manager so I'll need to
investigate it a bit perhaps...

Dave.
