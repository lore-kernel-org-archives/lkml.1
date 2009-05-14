Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZENQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZENQLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZENQLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:11:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53690 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZENQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:11:43 -0400
Date: Thu, 14 May 2009 10:11:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Check the argument of kunmap on architectures without
	highmem
Message-ID: <20090514161144.GT15360@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If you're using a non-highmem architecture, passing an argument
with the wrong type to kunmap() doesn't give you a warning because the
ifdef doesn't check the type.

Using a static inline function solves the problem nicely.

Reported-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 1fcb712..211ff44 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -55,7 +55,9 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-#define kunmap(page) do { (void) (page); } while (0)
+static inline void kunmap(struct page *page)
+{
+}
 
 static inline void *kmap_atomic(struct page *page, enum km_type idx)
 {

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
