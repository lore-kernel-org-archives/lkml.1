Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbYB0IFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbYB0IFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 03:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763784AbYB0IFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 03:05:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33824 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbYB0IFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 03:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QNGH44XSwE/Ol19NHTl/fCNu/jCKBg/2bRN8nPiQzVpsJ/VggQmh1t8YoYdxN98ZsM2ZdhmNNXZJxqpd78HU4BOlJ1SbRnaaYXhhlRZTf/aIIcctyn8GaiQjCVcXCkN7gAceXNHjZmCKH74MIu7bX3p+ndO+feMfK8eWnKBUzlc=
Message-ID: <84144f020802270005p3bfbd04ar9da2875218ef98c4@mail.gmail.com>
Date: Wed, 27 Feb 2008 10:05:04 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/28] Swap over NFS -v16
Cc: "Neil Brown" <neilb@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <1204099113.6242.353.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220144610.548202000@chello.nl>
	 <20080223000620.7fee8ff8.akpm@linux-foundation.org>
	 <18371.43950.150842.429997@notabene.brown>
	 <1204023042.6242.271.camel@lappy>
	 <18372.64081.995262.986841@notabene.brown>
	 <1204099113.6242.353.camel@lappy>
X-Google-Sender-Auth: 431c33bee954cbe9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Feb 27, 2008 at 9:58 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  > 1/ I note there is no way to tell if memory returned by kmalloc is
>  >   from the emergency reserve - which contrasts with alloc_page
>  >   which does make that information available through page->reserve.
>  >   This seems a slightly unfortunate aspect of the interface.
>
>  Yes, but alas there is no room to store such information in kmalloc().
>  That is, in a sane way. I think it was Daniel Phillips who suggested
>  encoding it in the return pointer by flipping the low bit - but that is
>  just too ugly and breaks all current kmalloc sites to boot.

Why can't you add a kmem_is_emergency() to SLUB that looks up the
cache/slab/page (whatever is the smallest unit of the emergency pool
here) for the object and use that?
