Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYISUki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYISUki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYISUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:40:11 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:34833 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbYISUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:40:09 -0400
Message-Id: <20080919203724.474751340@quilx.com>
References: <20080919203703.312007962@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Sep 2008 13:37:06 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
CC: linux-mm@kvack.org
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
Cc: penberg@cs.helsinki.fi
Subject: [patch 3/3] Increase default reserve percpu area
Content-Disposition: inline; filename=cpu_alloc_increase_percpu_default
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB now requires a portion of the per cpu reserve. There are on average
about 70 real slabs on a system (aliases do not count) and each needs 12 bytes
of per cpu space. Thats 840 bytes. In debug mode all slabs will be real slabs
which will make us end up with 150 -> 1800. Give it some slack and add 2000
bytes to the default size.

Things work fine without this patch but then slub will reduce the percpu reserve
for modules.

Also define a reserve if CONFIG_MODULES is off.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-09-19 15:04:21.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2008-09-19 15:05:31.000000000 -0500
@@ -38,9 +38,9 @@
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_AREA_SIZE
 #ifdef CONFIG_MODULES
-#define PERCPU_RESERVE_SIZE	8192
+#define PERCPU_RESERVE_SIZE	10000
 #else
-#define PERCPU_RESERVE_SIZE	0
+#define PERCPU_RESERVE_SIZE	2000
 #endif
 
 #define PERCPU_AREA_SIZE						\

-- 
