Return-Path: <linux-kernel-owner+w=401wt.eu-S936106AbXHGVC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106AbXHGVC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935628AbXHGUvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:51:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935620AbXHGUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:51:30 -0400
Date: Tue, 7 Aug 2007 13:45:36 -0700
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
       Dmitry Torokhov <dtor@mail.ru>
Subject: [2.6.22.2 review 32/84] Input: lifebook - fix an oops on Panasonic
	CF-18
Message-ID: <20070807204536.GG23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-lifebook-fix-an-oops-on-panasonic-cf-18.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@insightbb.com>

Input: lifebook - fix an oops on Panasonic CF-18

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/lifebook.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -109,7 +109,7 @@ static psmouse_ret_t lifebook_process_by
 {
 	struct lifebook_data *priv = psmouse->private;
 	struct input_dev *dev1 = psmouse->dev;
-	struct input_dev *dev2 = priv->dev2;
+	struct input_dev *dev2 = priv ? priv->dev2 : NULL;
 	unsigned char *packet = psmouse->packet;
 	int relative_packet = packet[0] & 0x08;
 

-- 
