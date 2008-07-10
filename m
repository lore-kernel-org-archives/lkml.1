Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYGJUrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYGJUrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGJUq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:46:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:38076 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYGJUq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,340,1212390000"; 
   d="scan'208";a="306837378"
From: "Luck, Tony" <tony.luck@intel.com>
To: "alan@redhat.com" <alan@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jul 2008 13:46:49 -0700
Subject: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Thread-Topic: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Thread-Index: AcjizhNmCx0J3A0DRMu7w3IRq+nQjQ==
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is "hidden" in arch/ia64 ... so it didn't get updated
by the Ldisc revamp.

Signed-off-by: Tony Luck <tony.luck@intel.com>


diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 23cafc8..f870bbf 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -354,8 +354,8 @@ static void rs_flush_buffer(struct tty_struct *tty)
        wake_up_interruptible(&tty->write_wait);

        if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-           tty->ldisc.write_wakeup)
-               (tty->ldisc.write_wakeup)(tty);
+           tty->ldisc.ops->write_wakeup)
+               (tty->ldisc.ops->write_wakeup)(tty);
 }

 /*
@@ -407,8 +407,9 @@ static void rs_unthrottle(struct tty_struct * tty)
 /*
  * rs_break() --- routine which turns the break handling on or off
  */
-static void rs_break(struct tty_struct *tty, int break_state)
+static int rs_break(struct tty_struct *tty, int break_state)
 {
+       return 0;
 }

 static int rs_ioctl(struct tty_struct *tty, struct file * file,
@@ -625,7 +626,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
        shutdown(info);
        if (tty->ops->flush_buffer)
                tty->ops->flush_buffer(tty);
-       if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
+       if (tty->ldisc.ops->flush_buffer) tty->ldisc.ops->flush_buffer(tty);
        info->event = 0;
        info->tty = NULL;
        if (info->blocked_open) {


