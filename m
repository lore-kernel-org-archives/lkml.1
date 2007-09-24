Return-Path: <linux-kernel-owner+w=401wt.eu-S1761079AbXIXQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761079AbXIXQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760459AbXIXQZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:47 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47342 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559AbXIXQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:44 -0400
Date: Mon, 24 Sep 2007 09:20:45 -0700
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
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [15/50] V4L: cx88: Avoid a NULL pointer dereference during
	mpeg_open()
Message-ID: <20070924162045.GP13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx88-avoid-a-null-pointer-dereference-during-mpeg_open.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit 48200baeab95fd39a7f4c4f3536c7142a64ac335)

[PATCH] V4L: cx88: Avoid a NULL pointer dereference during mpeg_open()

Bug: With a hardware encoder board installed as cx88[1] and a
non-encoder boards installed as cx88[0], an OOPS is generated
during cx8802_get_device() called from mpeg_open().

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-mpeg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -580,7 +580,7 @@ struct cx8802_dev * cx8802_get_device(st
 
 	list_for_each(list,&cx8802_devlist) {
 		h = list_entry(list, struct cx8802_dev, devlist);
-		if (h->mpeg_dev->minor == minor)
+		if (h->mpeg_dev && h->mpeg_dev->minor == minor)
 			return h;
 	}
 

-- 
