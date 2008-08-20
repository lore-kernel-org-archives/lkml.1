Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYHTNo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYHTNo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHTNou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:44:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYHTNot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:44:49 -0400
Subject: [PATCH] Reduce brokenness of CRIS headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jesper.nilsson@axis.com
Content-Type: text/plain
Date: Wed, 20 Aug 2008 14:44:45 +0100
Message-Id: <1219239885.2988.144.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I won't say 'fix', because they still look broken, although this will at
least allow 'make ARCH=CRIS headers_install' to _complete_. 

For headers which are exported, we should probably choose between
asm/arch-v10 and asm/arch-v32 by something that GCC defines -- we can't
rely on a generated symlink. And we certainly can't export an arch/
directory which doesn't even exist.

And the only thing that we seem to include from the arch/ directory is
<asm/arch/ptrace.h> from <asm/ptrace.h> ... and that isn't exported in
either arch-v10 or arch-v32 _anyway_.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

--- a/include/asm-cris/Kbuild
+++ b/include/asm-cris/Kbuild
@@ -1,6 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += arch/
 header-y += arch-v10/
 header-y += arch-v32/
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



