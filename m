Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZG3D2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZG3D2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 23:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZG3D2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 23:28:05 -0400
Received: from mga05.intel.com ([192.55.52.89]:43226 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbZG3D2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 23:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,292,1246863600"; 
   d="scan'208";a="479165221"
Subject: [SLUB] change kmem_cache->align to record the real alignment
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Jul 2009 11:28:11 +0800
Message-Id: <1248924491.2560.725.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache->align records the original align parameter value specified
by users. Function calculate_alignment might change it based on cache
line size. So change kmem_cache->align correspondingly.

﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6.31-rc3/mm/slub.c	2009-07-20 00:29:39.000000000 +0800
+++ linux-2.6.31-rc3_slubalign/mm/slub.c	2009-07-30 01:19:29.000000000 +0800
@@ -2400,6 +2400,7 @@ static int calculate_sizes(struct kmem_c
 	 * on bootup.
 	 */
 	align = calculate_alignment(flags, align, s->objsize);
+	s->align = align;
 
 	/*
 	 * SLUB stores one object immediately after another beginning from


