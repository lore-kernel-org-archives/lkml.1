Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZCSCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZCSCcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZCSCcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 22:32:04 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:59874
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753709AbZCSCcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 22:32:03 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 22:32:03 EDT
X-BigFish: VS-7(zz936eQzz1202h10c0jzzz2dh6bh65h)
X-Spam-TCS-SCL: 4:0
Message-ID: <49C1AB0E.5060800@am.sony.com>
Date: Wed, 18 Mar 2009 19:16:46 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@redhat.com
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [patch] one extra (incorrect) test in mask_ack_irq()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2009 02:16:53.0033 (UTC) FILETIME=[C4CF6190:01C9A838]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


preempt-irqs-core.patch added an incorrect check for the existence of
desc->chip->ack to mask_ack_irq()

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

--- linux-2.6.29-rc7/kernel/irq/chip.c	2009-03-18 17:58:03.000000000 -0800
+++ linux-2.6.29-rc7_new/kernel/irq/chip.c	2009-03-18 17:59:15.000000000 -0800
@@ -293,7 +293,6 @@ static inline void mask_ack_irq(struct i
 	if (desc->chip->mask_ack)
 		desc->chip->mask_ack(irq);
 	else {
-		if (desc->chip->ack)
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
 		if (desc->chip->ack)

