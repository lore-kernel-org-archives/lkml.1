Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbZHRVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbZHRVa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZHRVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:30:28 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60046 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZHRVa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:30:26 -0400
Subject: Re: [RFC][PATCH] flex_array: conditionally optimize out divides
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <e9c3a7c20908181102q6db970bav737cf26939f84c4c@mail.gmail.com>
References: <20090817204351.EEE0DDDB@kernel>
	 <e9c3a7c20908181102q6db970bav737cf26939f84c4c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 14:30:25 -0700
Message-Id: <1250631025.7335.996.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 11:02 -0700, Dan Williams wrote:
> > +       return flex_array_get_precalc(fa, part_nr, index_inside);
> > +}
> > +
> > +static inline int flex_array_put_es(struct flex_array *fa, int element_nr,
> > +               int element_size, void *src, gfp_t flags)
> > +{
> > +       int part_nr = __fa_element_to_part_nr(element_size, element_nr);
> > +       int index_inside = __fa_index_inside_part(element_size, element_nr);
> > +
> > +       if (element_nr >= fa->total_nr_elements)
> > +               return -ENOSPC;
> 
> ...and this one look like good candidates for unlikely() as these
> additional branches may be a concern for the fast path.

Personally, I think those macros are grossly overused.  I'm loathe to
use them unless there's actual profiling data showing that they make an
appreciable performance improvement or that the generated code is
unquestionably better.

-- Dave

