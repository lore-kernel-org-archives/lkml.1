Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXDZHCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXDZHCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXDZHCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:02:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41587 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933262AbXDZHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:02:33 -0400
Date: Thu, 26 Apr 2007 00:02:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [10/17] Variable Order Page Cache: Add clearing and flushing
 function
In-Reply-To: <20070424222306.764423792@sgi.com>
Message-ID: <Pine.LNX.4.64.0704260001540.30701@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070424222306.764423792@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, clameter@sgi.com wrote:

> +{									\
> +	memset(page_address(__page), (__offset), (__size));		\
> +	flush_mapping_page(__page);					\

This was borked. Dave does this patch make it work?

---
 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc7/include/linux/highmem.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/highmem.h	2007-04-25 23:59:33.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/highmem.h	2007-04-26 00:00:05.000000000 -0700
@@ -88,7 +88,7 @@ static inline void clear_highpage(struct
  */
 #define memclear_highpage_flush(__page,__offset,__size) \
 {									\
-	memset(page_address(__page), (__offset), (__size));		\
+	memset(page_address(__page) + (__offset), 0, (__size));		\
 	flush_mapping_page(__page);					\
 }
 #else
