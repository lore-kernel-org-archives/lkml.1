Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYFWC4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYFWC4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYFWCzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:55:49 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30162 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751531AbYFWCzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:55:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=qsGvIAtOttYyxsMbsKUkBxsWUwC05ZniQIctXU4p2Mm/z2LYJirWm0ScE6/DwQi2KgVvCYFPDtAqtWp1sxJOLf1eMFshrZo+EvO1btsogYSjm4QE92GS05oqyhZCcJDf6mtioqV/1jkW7E4Z9LDgFp191LyV3RF5Ow4n+PrdsYI=  ;
X-YMail-OSG: 9cgzrbgVM1l6rlR7nYCTaiR_iu4cfVgHjeFr09GJpo_NLsZV6YNtEjP7f7zAjFqhRmfcvvjASgnPGaHJs7qQV18wu260UPj90Bv9G7HASptbJYW3OzdWzzVDkCYvTKvKAqQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch] x86 supports NO_IRQ convention
Date: Sun, 22 Jun 2008 19:53:18 -0700
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221953.18849.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, x86 doesn't seem to support the NO_IRQ convention.  This means
that portable code can't use it.  Which in turn means that there's
no portable way for drivers to know whether they have been handed a
valid IRQ number (zero usually being valid).  Double-plus ungood.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
I suspect this has been discussed before, but I can't find any
written resolution ...

 include/asm-x86/irq.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/asm-x86/irq.h	2008-06-22 16:36:43.000000000 -0700
+++ b/include/asm-x86/irq.h	2008-06-22 16:37:06.000000000 -0700
@@ -3,3 +3,7 @@
 #else
 # include "irq_64.h"
 #endif
+
+#ifndef NO_IRQ
+#define NO_IRQ	((unsigned int)(-1))
+#endif
