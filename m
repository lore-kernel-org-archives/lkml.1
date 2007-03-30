Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXC3VJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXC3VJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXC3VJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:09:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58183 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbXC3VJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:24 -0400
Date: Fri, 30 Mar 2007 14:04:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 04/37] UML - fix epoll
Message-ID: <20070330210401.GE29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-fix-epoll.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Dike <jdike@addtoit.com>

UML/x86_64 needs the same packing of struct epoll_event as x86_64.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/eventpoll.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -31,12 +31,19 @@
 /* 
  * On x86-64 make the 64bit structure have the same alignment as the
  * 32bit structure. This makes 32bit emulation easier.
+ *
+ * UML/x86_64 needs the same packing as x86_64 - UML + UML_X86 +
+ * 64_BIT adds up to UML/x86_64.
  */
 #ifdef __x86_64__
 #define EPOLL_PACKED __attribute__((packed))
 #else
+#if defined(CONFIG_UML) && defined(CONFIG_UML_X86) && defined(CONFIG_64BIT)
+#define EPOLL_PACKED __attribute__((packed))
+#else
 #define EPOLL_PACKED
 #endif
+#endif
 
 struct epoll_event {
 	__u32 events;

-- 
