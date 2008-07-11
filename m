Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYGKQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYGKQVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYGKQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:21:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:64470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYGKQVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,346,1212390000"; 
   d="scan'208";a="308849398"
From: "Luck, Tony" <tony.luck@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "alan@redhat.com" <alan@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jul 2008 09:20:53 -0700
Subject: RE: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Thread-Topic: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Thread-Index: AcjjbyzURhX6pU9LQLWe4wD4HrN7OQAAmVJQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30653A0D8@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
 <20080711164221.163ab1df@lxorguk.ukuu.org.uk>
In-Reply-To: <20080711164221.163ab1df@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How does this look instead

@@ -490,12 +460,6 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
        unsigned int cflag = tty->termios->c_cflag;

-       if (   (cflag == old_termios->c_cflag)
-           && (   RELEVANT_IFLAG(tty->termios->c_iflag)
-               == RELEVANT_IFLAG(old_termios->c_iflag)))
-         return;

Since you deleted the only use of "cflag" in this function, you can delete
the declaration too.

@@ -623,9 +587,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
         * the line discipline to only process XON/XOFF characters.
         */
        shutdown(info);
-       if (tty->ops->flush_buffer)
-               tty->ops->flush_buffer(tty);
-       if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
+       rs_flush_buffer(tty);
+       tty_ldisc_flush(tty)

A ';' on the end of this line would make the compiler much happier :-)


With these two additions it looks great.

Thanks

-Tony
