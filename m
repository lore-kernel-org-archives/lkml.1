Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbXDKS3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbXDKS3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXDKS3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:29:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbXDKS3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:29:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fCAuBAaNf5jnHeI0n6Kajp0PAz1VLhCYjLUfQjcyeFUBMNLc+S7syV1dh7g/OaDM/
	hwQytuKpBBG7jhZx5IFVQ==
Message-ID: <b040c32a0704111129p5c81b6e8v815e63e550a56f1b@mail.gmail.com>
Date: Wed, 11 Apr 2007 11:29:45 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Zach Brown" <zach.brown@oracle.com>
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070411181514.GO28322@mami.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410235353.325A7346F64@localhost>
	 <20070410221849.dcec1ce3.akpm@linux-foundation.org>
	 <b040c32a0704110954q64694780v1d57937cfcc3466d@mail.gmail.com>
	 <20070411181514.GO28322@mami.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Zach Brown <zach.brown@oracle.com> wrote:
> > Sorry I wasn't thorough enough.  And partially because I was worried
> > about changing structure type for user space facing struct aio_ring.
> > Now that I looked through all arches, it looks safe as all arch's
> > atomic_t has the same size as int.
>
> > Here is the updated patch.
>
> > @@ -144,7 +144,7 @@ struct kiocb {
> >  struct aio_ring {
> >       unsigned        id;     /* kernel internal index number */
> >       unsigned        nr;     /* number of io_events */
> > -     unsigned        head;
> > +     atomic_t        head;
> >       unsigned        tail;
>
> Embedding an atomic_t in an ABI struct?  That makes everyone else
> nervous too, right?

sure, make me nervous at least.


> It may look safe on i386/x86-64 today, but this doesn't seem like wise
> practice.  Is there any reason to believe that atomic_t will never
> change size?  Does anything else do this already?
>
> If nothing else, the "unsigned" (should be __u32, sigh) could be cast to
> an atomic_t.

The atomic_t cast is equally iffy.  I don't know what would be a best solution.
