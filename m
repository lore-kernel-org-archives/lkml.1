Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZFXIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZFXIEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZFXIE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:04:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZFXIEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:04:25 -0400
Message-ID: <4A41DDE6.1090209@kernel.org>
Date: Wed, 24 Jun 2009 17:03:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       davem@davemloft.net
Subject: [PATCH 11/10] sparc64: fix build breakage introduced by percpu-convert-most
 patchset
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 08:03:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e74e396204bfcb67570ba4517b08f5918e69afea incorrectly added
added HAVE_LEGACY_PER_CPU_AREA to sparc64 although it already has been
converted to dynamic percpu allocator.  Drop both
HAVE_{LEGACY|DYNAMIC}_PER_CPU_AREA.

[ Impact: fix build breakage ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
---
This patch fixes build breakage caused by changed patch apply order.
Thanks.

 arch/sparc/Kconfig |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 7a8698b..4f6ed0f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -92,15 +92,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
-config HAVE_LEGACY_PER_CPU_AREA
-	def_bool y if SPARC64
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y if SPARC64
 
-config HAVE_DYNAMIC_PER_CPU_AREA
-	def_bool y if SPARC64
-
 config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y if SPARC64
-- 
1.6.0.2

