Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbZJPJUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbZJPJUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbZJPJUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:20:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:39117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbZJPJUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,572,1249282800"; 
   d="scan'208";a="737032534"
Subject: Re: [RFC 1/2] Unified UUID/GUID definition
From: Huang Ying <ying.huang@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200910161103.40689.laurent.pinchart@ideasonboard.com>
References: <1255501805.6047.1192.camel@yhuang-dev.sh.intel.com>
	 <200910161103.40689.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 17:19:42 +0800
Message-Id: <1255684782.1951.28.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:03 +0800, Laurent Pinchart wrote:
[...] 
> > +#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
> > +((uuid_le)								\
> > +{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff,
> >  \ +   (b) & 0xff, ((b) >> 8) & 0xff,					\
> > +   (c) & 0xff, ((c) >> 8) & 0xff,					\
> > +   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> > +
> > +#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
> > +((uuid_be)								\
> > +{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff,
> >  \ +   ((b) >> 8) & 0xff, (b) & 0xff,					\
> > +   ((c) >> 8) & 0xff, (c) & 0xff,					\
> > +   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> > +
> > +#define NULL_UUID_LE							\
> > +	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> > +		0x00, 0x00, 0x00, 0x00)
> > +
> > +#define NULL_UUID_BE							\
> > +	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> > +		0x00, 0x00, 0x00, 0x00)
> > +
> > +static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
> > +{
> > +	return memcmp(&u1, &u2, sizeof(uuid_le));
> > +}
> > +
> > +static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
> > +{
> > +	return memcmp(&u1, &u2, sizeof(uuid_be));
> > +}
> 
> Shouldn't you pass pointers to those functions instead ?

This is intended for a typical usage model (in fact copied from efi.h).

#define MY_UUID_LE	UUID_LE(...)

if (uuid_le_cmp(uuid, MY_UUID_LE)) {
	...
}

You need not define another variable for comparing with a UUID constant.

> It would also be nice to have a single uuid_cmp function. Would it be possible 
> to use typeof(), __builtin_types_compatible_p() and BUILD_BUG_ON_ZERO magic to 
> make sure both arguments are of the same type and one of uuid_be and uuid_le ? 
> It might no work with the Intel compiler though.

It seems a little tricky and complex. This is just a very simple
function.

Best Regards,
Huang Ying


