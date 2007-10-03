Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbXJCTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbXJCTJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXJCTJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:09:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXJCTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:09:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=G3Fd6KIsRxQF2D/4ItOOEW6nSCDAalyUDMI/mqbFiR8ofBTh140uFq3XhJ3sb3z5r
	+MHwKzaWwqZh8afMAz77g==
Message-ID: <b040c32a0710031208s5323d16ao47becace88c2bc79@mail.gmail.com>
Date: Wed, 3 Oct 2007 12:08:52 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
Subject: Re: [PATCH] hugetlb: Fix pool resizing corner case
Cc: "Adam Litke" <agl@us.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1191437948.4939.105.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003154748.19516.90317.stgit@kernel>
	 <1191433248.4939.79.camel@localhost>
	 <1191436392.19775.43.camel@localhost.localdomain>
	 <1191437948.4939.105.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Dave Hansen <haveblue@us.ibm.com> wrote:
> > Not quite.  Count can never go below the number of reserved pages plus
> > pages allocated to MAP_PRIVATE mappings.  That number is computed by:
> > (resv + (total - free)).
>
> So, (total - free) equals the number of MAP_PRIVATE pages?  Does that
> imply that all reserved pages are shared and that all shared pages are
> reserved?

no, not quite.  In-use huge page (total - free) can be both private or
shared.  resv_huge_pages counts number of pages that is committed for
shared mapping, but not yet faulted in.

What the equation does essentially is: resv_huge_pages + nr-huge-pages-in-use.

- Ken
