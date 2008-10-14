Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYJNJO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYJNJO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYJNJOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:14:17 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56838 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYJNJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:14:16 -0400
Message-Id: <20081014091413.437197300@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Oct 2008 11:12:52 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [RFC PATCH 5/5] hvc_console: Remove __devexit annotation of hvc_remove()
Content-Disposition: inline; filename=hvc/common/05_hvc_annotation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

Removed __devexit annotation of hvc_remove() to avoid a section mismatch
if the backend initialization fails and hvc_remove() must be used to
clean up allocated hvc structs (called in section __init or __devinit).

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |    2 +-
 drivers/char/hvc_console.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -806,7 +806,7 @@ struct hvc_struct __devinit *hvc_alloc(u
 }
 EXPORT_SYMBOL_GPL(hvc_alloc);
 
-int __devexit hvc_remove(struct hvc_struct *hp)
+int hvc_remove(struct hvc_struct *hp)
 {
 	unsigned long flags;
 	struct tty_struct *tty;
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -81,7 +81,7 @@ extern int hvc_instantiate(uint32_t vter
 extern struct hvc_struct * __devinit hvc_alloc(uint32_t vtermno, int data,
 				struct hv_ops *ops, int outbuf_size);
 /* remove a vterm from hvc tty operation (module_exit or hotplug remove) */
-extern int __devexit hvc_remove(struct hvc_struct *hp);
+extern int hvc_remove(struct hvc_struct *hp);
 
 /* data available */
 int hvc_poll(struct hvc_struct *hp);

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

