Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYABJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYABJ6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYABJ6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:58:08 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3740 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYABJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:58:07 -0500
Date: Wed, 2 Jan 2008 09:58:28 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: do not add new typedefs - is that for real?
Message-ID: <20080102095828.GC23164@shadowen.org>
References: <477A6732.4010609@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477A6732.4010609@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 06:15:46PM +0200, Boaz Harrosh wrote:
> I have this code:
> 
> <c_code>
> /* 
>  * osd-r10 4.12.5 Data-In and Data-Out buffer offsets
>  * byte offset = mantissa * (2^(exponent+8))
>  */
> typedef __be32 osd_cdb_offset;
> 
> osd_cdb_offset __osd_encode_offset(u64 offset, unsigned *padding,
> 	int min_shift, int max_shift);
> 
> struct osd_attributes_list_mode {
> 	__be32		get_attr_desc_bytes;
> 	osd_cdb_offset	get_attr_desc_offset;
> 
> 	__be32		get_attr_alloc_length;
> 	osd_cdb_offset	get_attr_offset;
> 
> 	__be32		set_attr_bytes;
> 	osd_cdb_offset	set_attr_offset;
> 	__be32 not_used;
> };
> </c_code>
> 
> 
> the osd_cdb_offset above is this special OSD-standard floating-point-like
> special type. It is of size 32 bit in special network order. What should
> I do then:
> 
> __be32 __osd_encode_offset(u64 offset, unsigned *padding,
> 	int min_shift, int max_shift);
> 
> But it is not a __be32. It is this special floating-point-like thingy!!!?
> How was __be32 defined with a #define???!!
> 
> Come on guys, it is not checkpatch.pl place to complain about good language
> constructs that can be misused. This is the maintainers and reviewers
> job to say that a: "typedef struct foo Foo;" is bad practice and we don't
> like it, but it can not be left to a script. "typedef"s should be used
> where they should be used.

It is checkpatch's role to point out things which are likely to be
wrong.  There will always be exceptions.  Lines whihc are much more
readable if they spill over 80 characters, typedefs which do make sense.
atomic_t's for example.  This may well be a valid use of them.  Note
that this is mentioned as a WARNING not an ERROR.  As is stated in the
patch submission notes, you are meant to be comfortable with everything
which checkpatch is still reporting.

checkpatch is a style _guide_, not the be all and end all.  It is meant
to carry a preferred style to try and maintain some consistency kernel
wide.

-apw
