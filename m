Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXD2IWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXD2IWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbXD2IWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:22:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932812AbXD2IWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:22:08 -0400
Date: Sun, 29 Apr 2007 01:22:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: bad_page from quicklist patches
Message-Id: <20070429012202.b0c11d4f.akpm@linux-foundation.org>
In-Reply-To: <20070429081610.5469.36016.sendpatchset@v0>
References: <20070429081610.5469.36016.sendpatchset@v0>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 01:16:10 -0700 Paul Jackson <pj@sgi.com> wrote:

> I am getting many 'bad_page' failures from the quicklist patches
> in 2.6.21-rc7-mm1.  I have bisected the problem down the following
> patches:
> 
>     quicklists-for-page-table-pages.patch
>     quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
>     quicklist-support-for-ia64.patch
>     quicklist-support-for-x86_64.patch
>     quicklist-support-for-sparc64.patch
> 
> This is on an ia64, compiled with the sn2_defconfig configuration.

That should have been fixed in -mm2, by the below:

--- a/include/linux/quicklist.h~quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix
+++ a/include/linux/quicklist.h
@@ -61,7 +61,7 @@ static inline void __quicklist_free(int 
 	if (unlikely(nid != numa_node_id())) {
 		if (dtor)
 			dtor(p);
-		free_hot_page(page);
+		__free_page(page);
 		return;
 	}
 
_

