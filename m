Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZJGGOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZJGGOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZJGGOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:14:43 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:33872 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZJGGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=Yuz+fghNoOv7ZPT5jyY/95nsFoyVgG9moAqnKPthw2xvgjsJCGBc5KLVsj+VurW/v0
         SZUd/pvVAW6DbrUeUGmCDEre2vzgGVxAgmCcGxStm22dr01A0M5th3ZtR4Hf9hPL/CHs
         1zbw3twTi3hURSx0N0u/qZDINSywmhY9TYQjc=
Date: Wed, 7 Oct 2009 14:12:23 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix two warnings on mm/percpu.c
Message-ID: <20091007061223.GA17794@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix those two warnings:

mm/percpu.c: In function ‘pcpu_embed_first_chunk’:
mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
mm/percpu.c:1879: warning: format ‘%lx’ expects type ‘long unsigned int’, but
argument 2 has type ‘size_t

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 mm/percpu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4a048ab..fc0fc6a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1817,7 +1817,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 	void *base = (void *)ULONG_MAX;
 	void **areas = NULL;
 	struct pcpu_alloc_info *ai;
-	size_t size_sum, areas_size, max_distance;
+	size_t size_sum, areas_size;
+	unsigned long max_distance;
 	int group, i, rc;
 
 	ai = pcpu_build_alloc_info(reserved_size, dyn_size, atom_size,
-- 
1.6.3.3

-- 
--------------------------------
http://zhwen.org - Open and Free
