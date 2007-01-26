Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbXAZWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbXAZWtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXAZWtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:49:06 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXAZWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:49:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VgKzhIAt74sTuaarGmVgo3TwyIDwXV6CjvmLOJGI8Le3X4OxXsS/cePX7RlTj+e/Q
	jt8kqJyzJUL0bP5Q7ETYA==
Message-ID: <b040c32a0701261448k122f5cc7q5368b3b16ee1dc1f@mail.gmail.com>
Date: Fri, 26 Jan 2007 14:48:44 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] Don't allow the stack to grow into hugetlb reserved regions
Cc: "Adam Litke" <agl@us.ibm.com>, "Andrew Morton" <akpm@osdl.org>,
       "William Irwin" <wli@holomorphy.com>,
       "David Gibson" <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0701262025590.22196@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070125214052.22841.33449.stgit@localhost.localdomain>
	 <Pine.LNX.4.64.0701262025590.22196@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/07, Hugh Dickins <hugh@veritas.com> wrote:
> Less trivial (and I wonder whether you've come to this from an ia64
> or a powerpc direction): I notice that ia64 has more stringent REGION
> checks in its ia64_do_page_fault, before calling expand_stack or
> expand_upwards.  So on that path, the usual path, I think your
> new check in acct_stack_growth is unnecessary on ia64;

I think you are correct. This appears to affect powerpc only. On ia64,
hugetlb lives in a completely different region and they can never step
into normal stack address space. And for x86, there isn't a thing called
"reserved address space" for hugetlb mapping.

        - Ken
