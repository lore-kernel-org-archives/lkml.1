Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYLCTuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYLCTuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYLCTuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:03 -0500
Received: from kroah.org ([198.145.64.141]:34466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754186AbYLCTuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:00 -0500
Date: Wed, 3 Dec 2008 11:48:15 -0800
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
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 002/104] USB: gadget rndis: stop windows self-immolation
Message-ID: <20081203194815.GC8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-gadget-rndis-stop-windows-self-immolation.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Brownell <dbrownell@users.sourceforge.net>

commit 9c264521a9f836541c122b00f505cfd60cc5bbb5 upstream.

Somewhere in the conversion of the RNDIS gadget code to the new
framework, the descriptor of its data interface seems to have
been copied from the CDC Ethernet driver.  Unfortunately that
means it got a nonzero altsetting ... which is incorrect.  Issue
uncovered by Richard Röjfors <richard.rojfors@endian.se>.

This patch fixes that problem, and resolves at least some cases
of Windows XP bluescreening itself.

Tested-by: Richard Röjfors <richard.rojfors@endian.se>.
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_rndis.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -172,7 +172,6 @@ static struct usb_interface_descriptor r
 	.bDescriptorType =	USB_DT_INTERFACE,
 
 	/* .bInterfaceNumber = DYNAMIC */
-	.bAlternateSetting =	1,
 	.bNumEndpoints =	2,
 	.bInterfaceClass =	USB_CLASS_CDC_DATA,
 	.bInterfaceSubClass =	0,

