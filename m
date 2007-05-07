Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbXEGWvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbXEGWvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXEGWvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:51:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:59739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbXEGWvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="243096664"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/3] kbuild: complain about missing system calls.
Date: Mon, 7 May 2007 15:51:49 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01719669@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1178577575.11851.242.camel@pmac.infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] kbuild: complain about missing system calls.
Thread-Index: AceQ+Jz8gIwOg9sCTteRbiIW897cQQAAWW9Q
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kees Cook" <kees@outflux.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2007 22:51:50.0825 (UTC) FILETIME=[4CCFA990:01C790FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could add them to scripts/checksyscalls.sh itself -- I think it's
> fairly unlikely that those are syscalls which a new arch port is going
> to 'forget' :)

Like this?

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index f98171f..4d49056 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -98,6 +98,14 @@ cat << EOF
 #define __IGNORE_setgid32
 #define __IGNORE_setfsuid32
 #define __IGNORE_setfsgid32
+/* ... some legacy names not used by ia64 */
+#define __IGNORE_fork
+#define __IGNORE_time
+#define __IGNORE_alarm
+#define __IGNORE_pause
+#define __IGNORE_utime
+#define __IGNORE_getpgrp
+#define __IGNORE_vfork
 
 /* Unmerged syscalls for AFS, STREAMS, etc. */
 #define __IGNORE_afs_syscall
