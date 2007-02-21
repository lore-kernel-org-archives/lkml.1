Return-Path: <linux-kernel-owner+w=401wt.eu-S965318AbXBUBzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318AbXBUBzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXBUBzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:55:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:35859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965318AbXBUBwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:52:38 -0500
Date: Tue, 20 Feb 2007 17:51:16 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Samuelsson <sam@home.se>, Andrew Morton <akpm@osdl.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 15/18] V4L: fix ks0127 status flags
Message-ID: <20070221015116.GP3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="V4L-fix-ks0127-status-flags.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Martin Samuelsson <sam@home.se>

Or status flags together in DECODER_GET_STATUS instead of and-zapping them.

(cherry picked from commit 55d5440d4587454628a850ce26703639885af678)

Signed-off-by: Martin Samuelsson <sam@home.se>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ks0127.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.18.7.orig/drivers/media/video/ks0127.c
+++ linux-2.6.18.7/drivers/media/video/ks0127.c
@@ -712,13 +712,13 @@ static int ks0127_command(struct i2c_cli
 		*iarg = 0;
 		status = ks0127_read(ks, KS_STAT);
 		if (!(status & 0x20))		 /* NOVID not set */
-			*iarg = (*iarg & DECODER_STATUS_GOOD);
+			*iarg = (*iarg | DECODER_STATUS_GOOD);
 		if ((status & 0x01))		      /* CLOCK set */
-			*iarg = (*iarg & DECODER_STATUS_COLOR);
+			*iarg = (*iarg | DECODER_STATUS_COLOR);
 		if ((status & 0x08))		   /* PALDET set */
-			*iarg = (*iarg & DECODER_STATUS_PAL);
+			*iarg = (*iarg | DECODER_STATUS_PAL);
 		else
-			*iarg = (*iarg & DECODER_STATUS_NTSC);
+			*iarg = (*iarg | DECODER_STATUS_NTSC);
 		break;
 
 	//Catch any unknown command

--
