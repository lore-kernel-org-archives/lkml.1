Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZIBDOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZIBDOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZIBDOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:14:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZIBDOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:14:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xQ4DOjbWyMftUvhnp8N+HWTEv7zUMQlJFed9dBPHy+LbT38Hyt+XRVBaufEvvNKRi
	kzJatu0JQpp1kCHO/N3/g==
Date: Tue, 1 Sep 2009 20:14:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/2 -mm] flex_array: add missing kerneldoc annotations
In-Reply-To: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909012014030.13377@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kerneldoc annotations for function formals of type
struct flex_array and gfp_t which are currently lacking.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/flex_array.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -46,6 +46,7 @@ static inline int elements_fit_in_base(struct flex_array *fa)
  * flex_array_alloc - allocate a new flexible array
  * @element_size:	the size of individual elements in the array
  * @total:		total number of elements that this should hold
+ * @flags:		page allocation flags to use for base array
  *
  * Note: all locking must be provided by the caller.
  *
@@ -111,6 +112,7 @@ static int fa_element_to_part_nr(struct flex_array *fa,
 
 /**
  * flex_array_free_parts - just free the second-level pages
+ * @fa:		the flex array from which to free parts
  *
  * This is to be used in cases where the base 'struct flex_array'
  * has been statically allocated and should not be free.
@@ -159,9 +161,12 @@ __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
 
 /**
  * flex_array_put - copy data into the array at @element_nr
- * @src:	address of data to copy into the array
+ * @fa:		the flex array to copy data into
  * @element_nr:	index of the position in which to insert
  * 		the new element.
+ * @src:	address of data to copy into the array
+ * @flags:	page allocation flags to use for array expansion
+ *
  *
  * Note that this *copies* the contents of @src into
  * the array.  If you are trying to store an array of
@@ -192,6 +197,7 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 
 /**
  * flex_array_clear - clear element in array at @element_nr
+ * @fa:		the flex array of the element.
  * @element_nr:	index of the position to clear.
  *
  * Locking must be provided by the caller.
@@ -218,8 +224,10 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 
 /**
  * flex_array_prealloc - guarantee that array space exists
+ * @fa:		the flex array for which to preallocate parts
  * @start:	index of first array element for which space is allocated
  * @end:	index of last (inclusive) element for which space is allocated
+ * @flags:	page allocation flags
  *
  * This will guarantee that no future calls to flex_array_put()
  * will allocate memory.  It can be used if you are expecting to
@@ -252,6 +260,7 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 
 /**
  * flex_array_get - pull data back out of the array
+ * @fa:		the flex array from which to extract data
  * @element_nr:	index of the element to fetch from the array
  *
  * Returns a pointer to the data at index @element_nr.  Note
@@ -289,6 +298,7 @@ static int part_is_free(struct flex_array_part *part)
 
 /**
  * flex_array_shrink - free unused second-level pages
+ * @fa:		the flex array to shrink
  *
  * Frees all second-level pages that consist solely of unused
  * elements.  Returns the number of pages freed.
