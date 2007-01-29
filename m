Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXA2Scz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXA2Scz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXA2Scz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:32:55 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXA2Scy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:32:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Cjw00PAH0sDYne+L/QMp5bT4omjSWk7837a+h67q4621OgWliPRONqdDDudx8pm2N
	6vhCtO/CzzfRtR/jj4c9A==
Message-ID: <b040c32a0701291032o431dce63xfc804dc7f9280ff2@mail.gmail.com>
Date: Mon, 29 Jan 2007 10:32:39 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] Don't allow the stack to grow into hugetlb reserved regions
Cc: "Adam Litke" <agl@us.ibm.com>, "Andrew Morton" <akpm@osdl.org>,
       "William Irwin" <wli@holomorphy.com>,
       "David Gibson" <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <Pine.LNX.4.64.0701291703530.31023@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070125214052.22841.33449.stgit@localhost.localdomain>
	 <Pine.LNX.4.64.0701262025590.22196@blonde.wat.veritas.com>
	 <b040c32a0701261448k122f5cc7q5368b3b16ee1dc1f@mail.gmail.com>
	 <Pine.LNX.4.64.0701270904360.15686@blonde.wat.veritas.com>
	 <b040c32a0701281227r11fe02eblba07df7aa7400787@mail.gmail.com>
	 <Pine.LNX.4.64.0701291703530.31023@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Hugh Dickins <hugh@veritas.com> wrote:
> But, never mind hugetlb, you still not quite convinced me that there's
> no problem at all with get_user_pages find_extend_vma growing on ia64.
>
> I repeat that ia64_do_page_fault has REGION tests to guard against
> expanding either kind of stack across into another region.  ia64_brk,
> ia64_mmap_check and arch_get_unmapped_area have RGN_MAP_LIMIT checks.
> But where is the equivalent paranoia when ptrace calls get_user_pages
> calls find_extend_vma?
>
> If your usual stacks face each other across the same region, they're
> not going to pose problem.  But what if someone mmaps MAP_GROWSDOWN
> near the base of a region, then uses ptrace to touch an address near
> the top of the region below?

OK, now I fully understand what you are after.  I kept on thinking in the
context of hugetlb. You are correct that ia64 does not have proper address
check for find_extend_vma() and it is indeed a potentially very bad bug in
there. I'm with you, I don't see the equivalent RGN_MAP_LIMIT check in the
get_user_pages() path.

Forwarding this to Tony as I don't have any access to ia64 machine anymore
to test/validate a fix.

    - Ken
