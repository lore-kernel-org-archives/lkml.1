Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZHDNQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZHDNQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZHDNQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:16:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:33387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbZHDNQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:16:48 -0400
Date: Tue, 4 Aug 2009 13:15:39 GMT
From: tip-bot for Frans Pop <elendil@planet.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, elendil@planet.nl, xiyou.wangcong@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, elendil@planet.nl, xiyou.wangcong@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200907232056.28635.elendil@planet.nl>
References: <200907232056.28635.elendil@planet.nl>
Subject: [tip:x86/kbuild] x86: Simplify the Makefile in a minor way through use of cc-ifversion
Message-ID: <tip-c7bd0414d681706a32105895cae20fb9090db52e@git.kernel.org>
Git-Commit-ID: c7bd0414d681706a32105895cae20fb9090db52e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 13:15:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7bd0414d681706a32105895cae20fb9090db52e
Gitweb:     http://git.kernel.org/tip/c7bd0414d681706a32105895cae20fb9090db52e
Author:     Frans Pop <elendil@planet.nl>
AuthorDate: Thu, 23 Jul 2009 20:56:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 14:32:24 +0200

x86: Simplify the Makefile in a minor way through use of cc-ifversion

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
LKML-Reference: <200907232056.28635.elendil@planet.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..1f3851a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -32,8 +32,8 @@ ifeq ($(CONFIG_X86_32),y)
 
         # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
         # a lot more stack due to the lack of sharing of stacklots:
-        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
-                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
+        KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
+				$(call cc-option,-fno-unit-at-a-time))
 
         # CPU-specific tuning. Anything which can be shared with UML should go here.
         include $(srctree)/arch/x86/Makefile_32.cpu
