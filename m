Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYLCTuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYLCTuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYLCTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:00 -0500
Received: from kroah.org ([198.145.64.141]:34447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754194AbYLCTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:49:59 -0500
Date: Wed, 3 Dec 2008 11:48:08 -0800
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
       Richard =?iso-8859-1?Q?R=C3=B6jfors?= <richard.rojfors@endian.se>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 001/104] USB: gadget rndis: send notifications
Message-ID: <20081203194808.GB8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-gadget-rndis-send-notifications.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Richard Röjfors <richard.rojfors@endian.se>

commit ff3495052af48f7a2bf7961b131dc9e161dae19c upstream.

It turns out that atomic_inc_return() returns the *new* value
not the original one, so the logic in rndis_response_available()
kept the first RNDIS response notification from getting out.
This prevented interoperation with MS-Windows (but not Linux).

Fix this to make RNDIS behave again.

Signed-off-by: Richard Röjfors <richard.rojfors@endian.se>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_rndis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -303,7 +303,7 @@ static void rndis_response_available(voi
 	__le32				*data = req->buf;
 	int				status;
 
-	if (atomic_inc_return(&rndis->notify_count))
+	if (atomic_inc_return(&rndis->notify_count) != 1)
 		return;
 
 	/* Send RNDIS RESPONSE_AVAILABLE notification; a

