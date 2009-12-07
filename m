Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZLGAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZLGAdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934603AbZLGAdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:33:02 -0500
Received: from kroah.org ([198.145.64.141]:34274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbZLGAMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.842360924@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Samek <martin@marsark.sytes.net>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [028/119] V4L/DVB (13079): dib0700: fixed xc2028 firmware loading kernel oops
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13079-dib0700-fixed-xc2028-firmware-loading-kernel-oops.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Martin Samek <martin@marsark.sytes.net>

commit 7646b9de26c54cf4bc9c446d7ada9f91ece31e0a upstream.

Fixing kernel oops when driver attemps to load xc2028 firmware.

Note by djh: the patch contribute by Martin is a port of a fix I made during
the PCTV 340e development.  It's a temporary workaround that fixes a regression
(an OOPS condition) and the real fix should be in the code that manages the
i2c master on the dib7000p.  But this fix does address the immmediate
regression and should be merged upstream until we do a cleaner fix.

Signed-off-by: Martin Samek <martin@marsark.sytes.net>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/dib7000p.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -1344,6 +1344,11 @@ struct dvb_frontend * dib7000p_attach(st
 	if (dib7000p_identify(st) != 0)
 		goto error;
 
+	/* FIXME: make sure the dev.parent field is initialized, or else
+	request_firmware() will hit an OOPS (this should be moved somewhere
+	more common) */
+	st->i2c_master.gated_tuner_i2c_adap.dev.parent = i2c_adap->dev.parent;
+
 	dibx000_init_i2c_master(&st->i2c_master, DIB7000P, st->i2c_adap, st->i2c_addr);
 
 	dib7000p_demod_reset(st);


