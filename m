Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXJCTEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXJCTEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXJCTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:03:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXJCTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:03:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=pRUwxYhw8wvCr7H0Bzh43sTIqTJVVdp00xPMWMxiEf4IW6aMQILtrWKGzvh/6VIO2
	77dtzV5oX7FbzEc8wXdXA==
Message-ID: <b040c32a0710031203s7cc7b84fyab907046d2d3c773@mail.gmail.com>
Date: Wed, 3 Oct 2007 12:03:36 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Adam Litke" <agl@us.ibm.com>
Subject: Re: [PATCH] hugetlb: Fix pool resizing corner case
Cc: "Dave Hansen" <haveblue@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1191436392.19775.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003154748.19516.90317.stgit@kernel>
	 <1191433248.4939.79.camel@localhost>
	 <1191436392.19775.43.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Adam Litke <agl@us.ibm.com> wrote:
> The key is that we don't want to shrink the pool below the number of
> pages we are committed to keeping around.  Before this patch, we only
> accounted for the pages we plan to hand out (reserved huge pages) but
> not the ones we've already handed out (total - free).  Does that make
> sense?

Good catch, adam.

>From what I can see, the statement
        if (count >= nr_huge_pages)
                return nr_huge_pages;

in set_max_huge_pages() is useless because (1) we recalculate "count"
variable below it; and (2) both try_to_free_low() and the while loop
below the call to try_to_free_low() will terminate correctly.  If you
feel like it, please clean it up as well.

If not, I'm fine with that.

Acked-by: Ken Chen <kenchen@google.com>
