Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYFYEsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYFYEsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYFYEhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:50 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37451 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756092AbYFYEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 25 of 36] x86_64: PSE no longer a hard requirement
X-Mercurial-Node: 9f98c7492b360ce4ff3bd90fad134a8301cbf5f9
Message-Id: <9f98c7492b360ce4ff3b.1214367561@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because Xen doesn't support PSE mappings in guests, all code which
assumed the presence of PSE has been changed to fall back to smaller
mappings if necessary.  As a result, PSE is optional rather than
required (though still used whereever possible).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/required-features.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/required-features.h b/include/asm-x86/required-features.h
--- a/include/asm-x86/required-features.h
+++ b/include/asm-x86/required-features.h
@@ -42,7 +42,7 @@
 #endif
 
 #ifdef CONFIG_X86_64
-#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
+#define NEED_PSE	0
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
 #define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))


