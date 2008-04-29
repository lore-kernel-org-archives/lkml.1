Return-Path: <linux-kernel-owner+w=401wt.eu-S1763875AbYD2Sw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763875AbYD2Sw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbYD2Su4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:50:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:51558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762050AbYD2Suz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:50:55 -0400
Date: Tue, 29 Apr 2008 11:49:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benedikt Spranger <b.spranger@linutronix.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Vernon Sauder <vernoninhand@gmail.com>
Subject: [06/12] USB: gadget: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE
	message
Message-ID: <20080429184936.GG24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-queue-usb-usb_cdc_get_encapsulated_response-message.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jan Altenberg <jan.altenberg@linutronix.de>

backport of 41566bcf35a8b23ce4715dadb5acfd1098c1d3e4

commit 0cf4f2de0a0f4100795f38ef894d4910678c74f8 introduced a bug, which
prevents sending an USB_CDC_GET_ENCAPSULATED_RESPONSE message. This
breaks the RNDIS initialization (especially / only Windoze machines
dislike this behavior...).

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/ether.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1561,6 +1561,7 @@ done_set_intf:
 				memcpy(req->buf, buf, n);
 				req->complete = rndis_response_complete;
 				rndis_free_response(dev->rndis_config, buf);
+				value = n;
 			}
 			/* else stalls ... spec says to avoid that */
 		}

-- 
