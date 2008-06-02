Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYFBGc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYFBGc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYFBGcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:32:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:52789 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYFBGct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mRFrVue6JpTd3CUux7DWpWQSA88yDeUHZA+6q0T7tR6aUw7VUYXrh5NE6pcq2JhgMqj2aIOhBzlS0QUPSFJ+RqpYOXjms1dssV1d3hPkEP8m6WJFP5JvSzSjJCn9sF15K5XB2EPv0brkJWqFRiiNRiCJsscE78QqZCgjk3beYHw=
Message-ID: <84144f020806012332n47ba7a7eg37a6892dbb059d09@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:32:48 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "David Howells" <dhowells@redhat.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080602055922.GA24626@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
	 <484256AA.3000709@cs.helsinki.fi>
	 <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI>
	 <20080601082427.GC25429@linux-sh.org>
	 <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI>
	 <20080601102401.GD25429@linux-sh.org>
	 <48427A13.7050704@cs.helsinki.fi>
	 <20080601112137.GE25429@linux-sh.org>
	 <Pine.LNX.4.64.0806011426150.17742@sbz-30.cs.Helsinki.FI>
	 <20080602055922.GA24626@linux-sh.org>
X-Google-Sender-Auth: 93df9cbfc0f13507
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Jun 2, 2008 at 8:59 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> In the kmem_cache_alloc() case calling ksize() there is bogus, the
> previous semantics for kobjsize() just defaulted to returning PAGE_SIZE
> for these, since page->index was typically 0. Presently if we ksize()
> those objects, we get bogus size results that are smaller than the
> minimum alignment size. So we still need a way to handle that, even if
> it's not frightfully accurate.
>
> If we go back and apply your PG_slab patch for SLUB + SLOB, then
> kobjsize() can just become:

What call-sites are using kmem_cache_alloc()? Can we convert them to
kmalloc() or page_alloc()? IIRC both Christoph and Matt opposed my
PG_slab patches.
