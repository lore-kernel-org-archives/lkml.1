Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0BPBOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:14:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab0BPBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:14:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BnF/f8wV6XKeUKPqSf6HXsm5D4/ReeexJ5Jb8YjxPn/AP77XdfCll5YKOiEHqCaaK
	fFgWi3yBGR4VFPagRsE2g==
Date: Mon, 15 Feb 2010 17:13:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm: add comment about deprecation of __GFP_NOFAIL
In-Reply-To: <20100216092147.85ef7619.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002151712290.23480@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com> <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
 <20100216092147.85ef7619.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > As I already explained when you first brought this up, the possibility of 
> > not invoking the oom killer is not unique to GFP_DMA, it is also possible 
> > for GFP_NOFS.  Since __GFP_NOFAIL is deprecated and there are no current 
> > users of GFP_DMA | __GFP_NOFAIL, that warning is completely unnecessary.  
> > We're not adding any additional __GFP_NOFAIL allocations.
> >
> 
> Please add documentation about that to gfp.h before doing this.
> Doing this without writing any documenation is laziness.
> (WARNING is a style of documentation.)
> 

This is already documented in the page allocator, but I guess doing it in 
include/linux/gfp.h as well doesn't hurt.



mm: add comment about deprecation of __GFP_NOFAIL

__GFP_NOFAIL was deprecated in dab48dab, so add a comment that no new 
users should be added.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/gfp.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -30,7 +30,8 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.
+ * cannot handle allocation failures.  This modifier is deprecated and no new
+ * users should be added.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *
