Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZDWH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZDWH3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZDWH10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:26 -0400
Received: from sous-sol.org ([216.99.217.87]:48154 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753182AbZDWH1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:18 -0400
Message-Id: <20090423072255.083243150@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuosugeek.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 019/100] drm/i915: check for -EINVAL from vm_insert_pfn
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-check-for-einval-from-vm_insert_pfn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

upstream commit: 959b887cf42fd63cf10e28a7f26126f78aa1c0b0

Indicates something is wrong with the mapping; and apparently triggers
in current kernels.

Signed-off-by: Jesse Barnes <jbarnes@virtuosugeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -603,6 +603,7 @@ int i915_gem_fault(struct vm_area_struct
 	case -EAGAIN:
 		return VM_FAULT_OOM;
 	case -EFAULT:
+	case -EINVAL:
 		return VM_FAULT_SIGBUS;
 	default:
 		return VM_FAULT_NOPAGE;

