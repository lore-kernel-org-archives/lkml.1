Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYB2L7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYB2L7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYB2L6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:58:55 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:28683 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYB2L6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:58:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=r9ipYS0Zw9RFtvMuuBKJjmbBLulV/P3bCMLkBL/LukVrmwb/87TWeZWZJtntm/1mBCWTI9Ee+ko0jdFXUHEzNT/Hc352dmwtCzpGKat6vtx4XUgIioLUNwZ8UziUOBVOznJ+EXTdzXjvOAQpuOCERe++wFbqIvf9S/z45880SAw=
Message-ID: <84144f020802290358t2774f7bwd87efe79e7bd4235@mail.gmail.com>
Date: Fri, 29 Feb 2008 13:58:52 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/28] Swap over NFS -v16
Cc: "Neil Brown" <neilb@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1204285912.6243.93.camel@lappy>
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
	 <84144f020802270005p3bfbd04ar9da2875218ef98c4@mail.gmail.com>
	 <1204285912.6243.93.camel@lappy>
X-Google-Sender-Auth: 7282dc19ef5601de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Feb 29, 2008 at 1:51 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  I made page->reserve into PG_emergency and made that bit stick for the
>  lifetime of that page allocation. I then made kmem_is_emergency() look
>  up the head page backing that allocation's slab and return
>  PageEmergency().

[snip]

On Fri, Feb 29, 2008 at 1:51 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  This is a stricter model than I had before, and has one ramification I'm
>  not entirely sure I like.
>
>  It means the page remains a reserve page throughout its lifetime, which
>  means the slab remains a reserve slab throughout its lifetime. Therefore
>  it may never be used for !reserve allocations. Which in turn generates
>  complexities for the partial list.

Hmm, so why don't we then clear the PG_emergency flag then and
allocate a new fresh page to the reserves?

On Fri, Feb 29, 2008 at 1:51 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  Does this sound like something I should pursuit? I feel it might
>  complicate the slab allocators too much..

I can't answer that question until I see the code ;-). But overall, I
think it's better to put that code in SLUB rather than trying to work
around it elsewhere. The fact is, as soon as you have some sort of
reservation for _objects_, you need help from the SLUB allocator.

                           Pekka
