Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbZHQXqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbZHQXqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZHQXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:46:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZHQXq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:46:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JUQw6OwajYzl2qqcojBoaunA8qC0jHhhZkhS3mQV03lB+VUqLSmoxMFnzbtpU20jZ
	uETGX0MbZLZszfGrYr8hQ==
Date: Mon, 17 Aug 2009 16:46:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/3] flex_array: declare parts member to have incomplete
 type
In-Reply-To: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0908171645520.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `parts' member of struct flex_array should evaluate to an incomplete
type so that sizeof() cannot be used and C99 does not require the
zero-length specification.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -21,7 +21,7 @@ struct flex_array {
 		struct {
 			int element_size;
 			int total_nr_elements;
-			struct flex_array_part *parts[0];
+			struct flex_array_part *parts[];
 		};
 		/*
 		 * This little trick makes sure that
