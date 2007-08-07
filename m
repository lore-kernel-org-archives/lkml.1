Return-Path: <linux-kernel-owner+w=401wt.eu-S937399AbXHGV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937399AbXHGV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935856AbXHGU45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935852AbXHGU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:55 -0400
Date: Tue, 7 Aug 2007 13:49:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, thomas@tungstengraphics.com,
       jesper.juhl@gmail.com, alanh@tungstengraphics.com
Subject: [2.6.22.2 review 74/84] cr_backlight_probe() allocates too little
	storage for struct cr_panel
Message-ID: <20070807204913.GX23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker noticed that we allocate too little storage for
"struct cr_panel *crp" in cr_backlight_probe().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Alan Hourihane <alanh@tungstengraphics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/backlight/cr_bllcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -174,7 +174,7 @@ static int cr_backlight_probe(struct pla
 	struct cr_panel *crp;
 	u8 dev_en;
 
-	crp = kzalloc(sizeof(crp), GFP_KERNEL);
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
 	if (crp == NULL)
 		return -ENOMEM;
 

-- 
