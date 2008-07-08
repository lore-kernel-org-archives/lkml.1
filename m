Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYGHX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYGHX15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbYGHXPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:10 -0400
Received: from gw.goop.org ([64.81.55.164]:51207 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 55 of 55] xen: update Kconfig to allow 64-bit Xen
X-Mercurial-Node: bf5e99a86c0e7b76cad06bafc353d2431e0a39ee
Message-Id: <bf5e99a86c0e7b76cad0.1215554837@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow Xen to be enabled on 64-bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,8 +6,8 @@
 	bool "Xen guest support"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
-	depends on X86_32
-	depends on X86_CMPXCHG && X86_TSC && X86_PAE && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_64 || (X86_32 && X86_PAE && !(X86_VISWS || X86_VOYAGER))
+	depends on X86_CMPXCHG && X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
@@ -15,10 +15,11 @@
 
 config XEN_MAX_DOMAIN_MEMORY
        int "Maximum allowed size of a domain in gigabytes"
-       default 8
+       default 8 if X86_32
+       default 32 if X86_64
        depends on XEN
        help
          The pseudo-physical to machine address array is sized
          according to the maximum possible memory size of a Xen
          domain.  This array uses 1 page per gigabyte, so there's no
-         need to be too stingy here.
\ No newline at end of file
+         need to be too stingy here.


