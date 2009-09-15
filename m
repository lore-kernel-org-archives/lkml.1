Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZIOSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZIOSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZIOSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:25:25 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:23937 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbZIOSZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:25:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cleanup legacy console_print function
Date: Tue, 15 Sep 2009 11:25:00 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501F10104@exchange.ZeugmaSystems.local>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E05DBC6E@orsmsx505.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cleanup legacy console_print function
Thread-Index: Aco2LoGlxTtn2kTfTw6+AaWuvqT5ZgAABkswAAA3iUAAAIM1EA==
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0FF17@exchange.ZeugmaSystems.local> <200909151127.10697.bjorn.helgaas@hp.com> <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local> <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com> <DDFD17CC94A9BD49A82147DDF7D545C501F100EB@exchange.ZeugmaSystems.local> <57C9024A16AD2D4C97DC78E552063EA3E05DBC6E@orsmsx505.amr.corp.intel.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, <linux-ia64@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On ia64 (and I think most other assemblers) it is not
>necessary to provide any kind of "extern" declaration
>before using external symbols.


Ok, here goes:

From: Anirban Sinha <asinha@zeugmasystems.com>
Date: Tue, 15 Sep 2009 11:19:29 -0700
Subject: Fix ia64 build breakage. 

On ia64 it is not necessary to provide any kind of "extern" declaration
before using external symbols.


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 arch/ia64/kernel/head.S    |    1 -
 arch/ia64/kernel/head.h    |    1 -
 arch/ia64/kernel/process.c |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)
 delete mode 100644 arch/ia64/kernel/head.h

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index e6c5c3d..23f846d 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -34,7 +34,6 @@
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
-#include "head.h"

 #ifdef CONFIG_HOTPLUG_CPU
 #define SAL_PSR_BITS_TO_SET                            \
diff --git a/arch/ia64/kernel/head.h b/arch/ia64/kernel/head.h
deleted file mode 100644
index 2e2ac68..0000000
--- a/arch/ia64/kernel/head.h
+++ /dev/null
@@ -1 +0,0 @@
-extern void console_print(const char *s);
--
1.6.4

