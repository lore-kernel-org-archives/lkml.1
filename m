Return-Path: <linux-kernel-owner+w=401wt.eu-S967536AbXEHSfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967536AbXEHSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967403AbXEHSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:35:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:64885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966440AbXEHSfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:35:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,506,1170662400"; 
   d="scan'208";a="243420157"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/3] kbuild: complain about missing system calls.
Date: Tue, 8 May 2007 11:35:27 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01719AFB@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070508182424.GA31516@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] kbuild: complain about missing system calls.
Thread-Index: AceRnf6tsuy4eucITmWw6TVHKQ4NkgAANhNw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
CC: "David Woodhouse" <dwmw2@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kees Cook" <kees@outflux.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2007 18:35:28.0329 (UTC) FILETIME=[A68ACB90:01C7919F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks more complex than necessary.  Why do you want to execute
an arch specific script to list the __IGNORE symbols?  That would
allow an arch to generate a list with sed/perl/etc. but that
looks like overkill.

If you just have an arch specific file with the right defines.
E.g. for x86_64 in include/asm-x86_64/ignore_syscalls:

#include __IGNORE_getcpu

Then the checksyscalls.sh changes would just be something like
(do I need a ${srctree} before the include??):

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index f98171f..616f7c5 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -105,6 +105,10 @@ cat << EOF
 #define __IGNORE_putpmsg
 #define __IGNORE_vserver
 EOF
+if [ -f include/asm/ignore_syscalls ]
+then
+	cat include/asm/ignore_syscalls
+fi
 }
 
 syscall_list() {

-Tony
