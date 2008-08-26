Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYHZRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYHZRBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYHZRBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:01:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46873 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYHZRBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:01:07 -0400
Subject: Re: [RFC v2][PATCH 7/9] Infrastructure for shared objects
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Louis.Rilling@kerlabs.com
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <20080821104016.GJ581@hawkmoon.kerlabs.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202306170.17436@takamine.ncl.cs.columbia.edu>
	 <20080821104016.GJ581@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 10:01:04 -0700
Message-Id: <1219770064.8680.28.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 12:40 +0200, Louis Rilling wrote:
> 
> > +struct cr_objhash {
> > +     struct cr_obj **hash;
> > +     int next_tag;
> > +};
> > +
> > +#define CR_OBJHASH_NBITS  10 /* 10 bits = 1K buckets */
> > +#define CR_OBJHASH_ORDER  0  /* 1K buckets * 4 bytes/bucket = 1
> page */
> 
> Only true when PAGE_SIZE == 4K and in 32bits. Perhaps like below?
> 
> #define CR_OBJHASH_BUCKET_NBITS (BITS_PER_LONG == 64 ? 3 : 2)
> #define CR_MIN_OBJHASH_NBITS ((PAGE_SHIFT - CR_OBJHASH_BUCKET_NBITS)
> #define CR_OBJHASH_NBITS (CR_MIN_OBJHASH_NBITS >= 10 ?
> CR_MIN_OBJHASH_NBITS : 10)
> #define CR_OBJHASH_ORDER (CR_OBJHASH_NBITS + CR_OBJHASH_BUCKET_NBITS -
> PAGE_SHIFT)

Gah.  Can't we just use the existing radix tree or hash implementations
we already have?

-- Dave

