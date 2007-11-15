Return-Path: <linux-kernel-owner+w=401wt.eu-S1765404AbXKOVHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765404AbXKOVHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765628AbXKOVGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:06:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42929 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763585AbXKOVGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:06:51 -0500
Subject: Re: [RFC 5/7] LTTng instrumentation mm
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20071113194025.150641834@polymtl.ca>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 13:06:23 -0800
Message-Id: <1195160783.7078.203.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2007-11-13 at 14:33 -0500, Mathieu Desnoyers wrote:
>  linux-2.6-lttng/mm/page_io.c        2007-11-13 09:49:35.000000000 -0500
> @@ -114,6 +114,7 @@ int swap_writepage(struct page *page, st
>                 rw |= (1 << BIO_RW_SYNC);
>         count_vm_event(PSWPOUT);
>         set_page_writeback(page);
> +       trace_mark(mm_swap_out, "address %p", page_address(page));
>         unlock_page(page);
>         submit_bio(rw, bio);
>  out:

I'm not sure all this page_address() stuff makes any sense on highmem
systems.  How about page_to_pfn()?

I also have to wonder if you should be hooking into count_vm_event() and
using those.  Could you give a high-level overview of exactly why you
need these hooks, and perhaps what you expect from future people adding
things to the VM?

-- Dave

