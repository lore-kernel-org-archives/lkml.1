Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbZENXEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbZENXEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762253AbZENW6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:31 -0400
Received: from kroah.org ([198.145.64.141]:45958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762237AbZENW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:37 2009
Message-Id: <20090514225237.209345581@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:31 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 05/28] USB: Gadget: fix UTF conversion in the usbstring library
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=usb-gadget-fix-utf-conversion-in-the-usbstring-library.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0f43158caddcbb110916212ebe4e39993ae70864 upstream.

This patch (as1234) fixes a bug in the UTF8 -> UTF-16 conversion
routine in the gadget/usbstring library.  In a UTF-8 multi-byte
sequence, all bytes after the first should have their high-order
two bits set to 10, not 11.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/usbstring.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/usbstring.c
+++ b/drivers/usb/gadget/usbstring.c
@@ -38,7 +38,7 @@ static int utf8_to_utf16le(const char *s
 				uchar = (c & 0x1f) << 6;
 
 				c = (u8) *s++;
-				if ((c & 0xc0) != 0xc0)
+				if ((c & 0xc0) != 0x80)
 					goto fail;
 				c &= 0x3f;
 				uchar |= c;
@@ -49,13 +49,13 @@ static int utf8_to_utf16le(const char *s
 				uchar = (c & 0x0f) << 12;
 
 				c = (u8) *s++;
-				if ((c & 0xc0) != 0xc0)
+				if ((c & 0xc0) != 0x80)
 					goto fail;
 				c &= 0x3f;
 				uchar |= c << 6;
 
 				c = (u8) *s++;
-				if ((c & 0xc0) != 0xc0)
+				if ((c & 0xc0) != 0x80)
 					goto fail;
 				c &= 0x3f;
 				uchar |= c;


