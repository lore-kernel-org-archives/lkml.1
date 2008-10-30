Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYJ3UyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYJ3UyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJ3UyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:54:17 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3799 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJ3UyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:54:16 -0400
Date: Thu, 30 Oct 2008 21:54:10 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: emit loglevel for printk output
Message-ID: <20081030205410.GH11214@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I propose a character before each logged line so that one can easily grep
through dmesg output for errors/warnings/etc.
It's just a suggestion, maybe there are better ways. E.g. iirc openbsd
uses colors.
errors/criticals/fatals: -
warnings: !
debugging: #
info: +

Signed-off: folkert van heusden <folkert@vanheusden.com>

--- linux-source-2.6.27/kernel/printk.c.org	2008-10-30 17:07:02.000000000 +0100
+++ linux-source-2.6.27/kernel/printk.c	2008-10-30 21:07:17.000000000 +0100
@@ -730,6 +730,16 @@
 			printed_len += 3;
 			new_text_line = 0;
 
+			if (current_log_level <= (KERN_ERR[1] - '0'))
+				emit_log_char('-');
+			else if (current_log_level == (KERN_WARNING[1] - '0'))
+				emit_log_char('!');
+			else if (current_log_level == (KERN_DEBUG[1] - '0'))
+				emit_log_char('#');
+			else
+				emit_log_char('+');
+			emit_log_char(' ');
+
 			if (printk_time) {
 				/* Follow the token with the time */
 				char tbuf[50], *tp;


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
