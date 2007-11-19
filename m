Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbXKSSHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbXKSSHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXKSSHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:07:18 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48213 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXKSSHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:07:15 -0500
Subject: Re: [RFC 5/7] LTTng instrumentation mm
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071116144742.GA17255@Krystal>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost>
	 <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost>
	 <20071116144742.GA17255@Krystal>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 10:07:05 -0800
Message-Id: <1195495626.27759.119.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 09:47 -0500, Mathieu Desnoyers wrote:
> * Dave Hansen (haveblue@us.ibm.com) wrote:
> > For most (all?) architectures, the PFN and the virtual address in the
> > kernel's linear are interchangeable with pretty trivial arithmetic.  All
> > pages have a pfn, but not all have a virtual address.  Thus, I suggested
> > using the pfn.  What kind of virtual addresses are you talking about?
> > 
> 
> Hrm, in asm-generic/memory_model.h, we have various versions of
> __page_to_pfn. Normally they all cast the result to (unsigned long),
> except for :
> 
> 
> #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
> 
> /* memmap is virtually contigious.  */
> #define __pfn_to_page(pfn)      (vmemmap + (pfn))
> #define __page_to_pfn(page)     ((page) - vmemmap)
> 
> So I guess the result is a pointer ? Should this be expected ?

Nope.  'pointer - pointer' is an integer.  Just solve this equation for
integer:

	'pointer + integer = pointer'

-- Dave

