Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXBNTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXBNTUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXBNTUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:20:42 -0500
Received: from kanga.kvack.org ([66.96.29.28]:50658 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbXBNTUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:20:42 -0500
Date: Wed, 14 Feb 2007 17:17:02 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use movntq version of fast_clear_page/fast_copy_page on Geode
Message-ID: <20070214191702.GA5071@dmt.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


movntq instruction is supported by Geode CPU's, so use
fast_clear_page/fast_copy_page versions that have it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/i386/lib/mmx.c b/arch/i386/lib/mmx.c
index 28084d2..ddc1421 100644
--- a/arch/i386/lib/mmx.c
+++ b/arch/i386/lib/mmx.c
@@ -121,7 +121,7 @@ void *_mmx_memcpy(void *to, const void *
 	return p;
 }
 
-#ifdef CONFIG_MK7
+#if defined (CONFIG_MK7) || defined(CONFIG_MGEODE_LX)
 
 /*
  *	The K7 has streaming cache bypass load/store. The Cyrix III, K6 and

