Return-Path: <linux-kernel-owner+w=401wt.eu-S1161353AbXDKWy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161353AbXDKWy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161351AbXDKWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:25 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55554 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161349AbXDKWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:20 -0400
Date: Wed, 11 Apr 2007 15:51:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Oberritter <obi@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 08/31] DVB: tda10086: fix DiSEqC message length
Message-ID: <20070411225140.GI24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-tda10086-fix-diseqc-message-length.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andreas Oberritter <obi@linuxtv.org>

DVB: tda10086: fix DiSEqC message length

Setting the message length to zero means to send one byte, so you need a
subtraction instead of an addition.

(cherry picked from commit d420cb44693b8370cbf06c3e31b4b5dec66c9f86)

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/tda10086.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -212,7 +212,7 @@ static int tda10086_send_master_cmd (str
 	for(i=0; i< cmd->msg_len; i++) {
 		tda10086_write_byte(state, 0x48+i, cmd->msg[i]);
 	}
-	tda10086_write_byte(state, 0x36, 0x08 | ((cmd->msg_len + 1) << 4));
+	tda10086_write_byte(state, 0x36, 0x08 | ((cmd->msg_len - 1) << 4));
 
 	tda10086_diseqc_wait(state);
 

-- 
