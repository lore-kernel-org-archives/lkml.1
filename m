Return-Path: <linux-kernel-owner+w=401wt.eu-S936231AbXHGVHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231AbXHGVHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935758AbXHGUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59427 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935749AbXHGUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:06 -0400
Date: Tue, 7 Aug 2007 13:46:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, nils.neumann@rwth-aachen.de,
       daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch
Subject: [2.6.22.2 review 40/84] pcmcia: give socket time to power down
Message-ID: <20070807204608.GP23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pcmcia-give-socket-time-to-power-down.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Give sockets up to 100ms of additional time to power down.  otherwise we
might generate false warnings with KERN_ERR priority (like in bug #8262).

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Nils Neumann <nils.neumann@rwth-aachen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/cs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -409,6 +409,9 @@ static void socket_shutdown(struct pcmci
 #endif
 	s->functions = 0;
 
+	/* give socket some time to power down */
+	msleep(100);
+
 	s->ops->get_status(s, &status);
 	if (status & SS_POWERON) {
 		printk(KERN_ERR "PCMCIA: socket %p: *** DANGER *** unable to remove socket power\n", s);

-- 
