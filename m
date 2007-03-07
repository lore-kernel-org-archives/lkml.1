Return-Path: <linux-kernel-owner+w=401wt.eu-S1422930AbXCGRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930AbXCGRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXCGRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:44407 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422908AbXCGRSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:12 -0500
Message-Id: <20070307171634.962881319@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       jirislaby@gmail.com
Subject: [patch 090/101] Char: specialix, isr have 2 params
Content-Disposition: inline; filename=char-specialix-isr-have-2-params.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jiri Slaby <jirislaby@gmail.com>

specialix, isr have 2 params

pt_regs are no longer the third parameter of isr, call sx_interrupt without
it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/char/specialix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/char/specialix.c
+++ linux-2.6.20.1/drivers/char/specialix.c
@@ -459,7 +459,7 @@ void missed_irq (unsigned long data)
 	if (irq) {
 		printk (KERN_INFO "Missed interrupt... Calling int from timer. \n");
 		sx_interrupt (((struct specialix_board *)data)->irq,
-		              (void*)data, NULL);
+				(void*)data);
 	}
 	missed_irq_timer.expires = jiffies + sx_poll;
 	add_timer (&missed_irq_timer);

--
