Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbXFNTlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbXFNTlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXFNTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:40:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50432 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751333AbXFNTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:53 -0400
Message-Id: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:39 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the page cache handling by replacing
open coded shifts and adds through inline function calls.

The ultimate goal is to replace all uses of PAGE_CACHE_xxx in the
kernel through the use of these functions. All the functions take
a mapping parameter. This is in anticipation of support for higher order
pages in the page cache (like demonstrated by the Large Blocksize patchset).

It will take some time to get through all of the kernel source code.
The patches here convert only the core VM. We can likely do much
of the rest against Andrew's tree shortly before the merge window
opens for 2.6.23.

This patchset should have no effect. Both PAGE_CACHE_xxx and
page_cache-xxx functions can coexist while the conversion is
in progress. As long as filesystems / device drivers only use
PAGE_SIZE pages they can stay they are even if some file systems
and devices start to support higher order pages.

Patchset against 2.6.22-rc4-mm2

After this patchset more cleanups will follow against filesystems.
I have patches for 3 filesystems so far.

-- 
