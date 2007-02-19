Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXBSTey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXBSTey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbXBSTey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:34:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49369 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbXBSTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:34:53 -0500
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API
From: Adam Litke <agl@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1171910581.3531.89.camel@laptopd505.fenrus.org>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
	 <1171910581.3531.89.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 13:34:51 -0600
Message-Id: <1171913691.22940.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 19:43 +0100, Arjan van de Ven wrote:
> On Mon, 2007-02-19 at 10:31 -0800, Adam Litke wrote:
> > The page tables for hugetlb mappings are handled differently than page tables
> > for normal pages.  Rather than integrating multiple page size support into the
> > main VM (which would tremendously complicate the code) some hooks were created.
> > This allows hugetlb special cases to be handled "out of line" by a separate
> > interface.
> 
> ok it makes sense to clean this up.. what I don't like is that there
> STILL are all the double cases... for this to work and be worth it both
> the common case and the hugetlb case should be using the ops structure
> always! Anything else and you're just replacing bad code with bad
> code ;(

Hmm.  Do you think everyone would support an extra pointer indirection
for every handle_pte_fault() call?  If not, then I definitely wouldn't
mind creating a default_pagetable_ops and calling into that.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

