Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbZBKAsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbZBKAsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbZBKA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:29:00 -0500
Received: from kroah.org ([198.145.64.141]:51704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756436AbZBKA26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:58 -0500
Date: Tue, 10 Feb 2009 16:26:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dean Nelson <dcn@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 56/56] genirq: NULL struct irq_descs member name in
	dynamic_irq_cleanup()
Message-ID: <20090211002610.GE14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="genirq-null-struct-irq_desc-s-member-name-in-dynamic_irq_cleanup.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Dean Nelson <dcn@sgi.com>

commit b6f3b7803a9231eddc36d0a2a6d2d8105ef89344 upstream.

If the member 'name' of the irq_desc structure happens to point to a
character string that is resident within a kernel module, problems ensue
if that module is rmmod'd (at which time dynamic_irq_cleanup() is called)
and then later show_interrupts() is called by someone.

It is also not a good thing if the character string resided in kmalloc'd
space that has been kfree'd (after having called dynamic_irq_cleanup()).
dynamic_irq_cleanup() fails to NULL the 'name' member and
show_interrupts() references it on a few architectures (like h8300, sh and
x86).

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/chip.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -78,6 +78,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->name = NULL;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 

