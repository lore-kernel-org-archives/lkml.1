Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbYBGUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbYBGUwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbYBGUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:38054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751AbYBGUuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:35 -0500
Date: Thu, 7 Feb 2008 12:46:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>
Subject: [patch 04/45] USB: keyspan: Fix oops
Message-ID: <20080207204643.GE16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-keyspan-fix-oops.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

If we get a data URB back from the hardware after we have put the tty to
bed we go kaboom. Fortunately all we need to do is process the URB
without trying to ram its contents down the throat of an ex-tty.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/keyspan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -838,7 +838,7 @@ static void	usa49_indat_callback(struct 
 
 	port = (struct usb_serial_port *) urb->context;
 	tty = port->tty;
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no error on any byte */

-- 
