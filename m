Return-Path: <linux-kernel-owner+w=401wt.eu-S1764420AbZGAAys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764420AbZGAAys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761356AbZGAAeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:36 -0400
Received: from kroah.org ([198.145.64.141]:60230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761415AbZGAAed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:21 2009
Message-Id: <20090701002421.479018764@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 029/108] epca: fix test_bit parameters
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=epca-fix-test_bit-parameters.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit c3301a5c04800bcf8afc8a815bf9e570a4e25a08 upstream.

Switch from ASYNC_* to ASYNCB_*, because test_bit expects
bit number, not mask.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/epca.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1518,7 +1518,7 @@ static void doevent(int crd)
 		if (event & MODEMCHG_IND) {
 			/* A modem signal change has been indicated */
 			ch->imodem = mstat;
-			if (test_bit(ASYNC_CHECK_CD, &ch->port.flags)) {
+			if (test_bit(ASYNCB_CHECK_CD, &ch->port.flags)) {
 				/* We are now receiving dcd */
 				if (mstat & ch->dcd)
 					wake_up_interruptible(&ch->port.open_wait);
@@ -1765,9 +1765,9 @@ static void epcaparam(struct tty_struct 
 		 * that the driver will wait on carrier detect.
 		 */
 		if (ts->c_cflag & CLOCAL)
-			clear_bit(ASYNC_CHECK_CD, &ch->port.flags);
+			clear_bit(ASYNCB_CHECK_CD, &ch->port.flags);
 		else
-			set_bit(ASYNC_CHECK_CD, &ch->port.flags);
+			set_bit(ASYNCB_CHECK_CD, &ch->port.flags);
 		mval = ch->m_dtr | ch->m_rts;
 	} /* End CBAUD not detected */
 	iflag = termios2digi_i(ch, ts->c_iflag);
@@ -2244,7 +2244,8 @@ static void do_softint(struct work_struc
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
 				tty_hangup(tty);
 				wake_up_interruptible(&ch->port.open_wait);
-				clear_bit(ASYNC_NORMAL_ACTIVE, &ch->port.flags);
+				clear_bit(ASYNCB_NORMAL_ACTIVE,
+						&ch->port.flags);
 			}
 		}
 		tty_kref_put(tty);


