Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXC3VMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXC3VMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXC3VL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:11:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51614 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbXC3VLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:37 -0400
Date: Fri, 30 Mar 2007 14:06:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Thomas Viehweger <Thomas.Viehweger@marconi.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 24/37] DVB: isl6421: dont reference freed memory
Message-ID: <20070330210623.GA29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-isl6421-don-t-reference-freed-memory.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Viehweger <Thomas.Viehweger@marconi.com>

DVB: isl6421: don't reference freed memory

After freeing a block there should be no reference to this block.

(cherry picked from commit 09d4895488d4df5c58b739573846f514ceabc911)

Signed-off-by: Thomas Viehweger <Thomas.Viehweger@marconi.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/isl6421.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb/frontends/isl6421.c
+++ b/drivers/media/dvb/frontends/isl6421.c
@@ -122,6 +122,7 @@ struct dvb_frontend *isl6421_attach(stru
 	/* detect if it is present or not */
 	if (isl6421_set_voltage(fe, SEC_VOLTAGE_OFF)) {
 		kfree(isl6421);
+		fe->sec_priv = NULL;
 		return NULL;
 	}
 

-- 
