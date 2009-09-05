Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbZIEAYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbZIEAYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbZIEAYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:24:23 -0400
Received: from kroah.org ([198.145.64.141]:42286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbZIEAV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:57 2009
Message-Id: <20090905001457.040714928@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 63/71] ar9170: fix read & write outside array bounds
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=ar9170-fix-read-write-outside-array-bounds.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dan Carpenter <error27@gmail.com>

commit e9d126cdfa60b575f1b5b02024c4faee27dccf07 upstream.

Backport done by Christian Lamparter <chunkeey@googlemail.com>

queue == __AR9170_NUM_TXQ would cause a bug on the next line.

found by Smatch ( http://repo.or.cz/w/smatch.git ).

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ar9170/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -1486,13 +1486,14 @@ static int ar9170_conf_tx(struct ieee802
 	int ret;
 
 	mutex_lock(&ar->mutex);
-	if ((param) && !(queue > ar->hw->queues)) {
+	if (queue < __AR9170_NUM_TXQ) {
 		memcpy(&ar->edcf[ar9170_qos_hwmap[queue]],
 		       param, sizeof(*param));
 
 		ret = ar9170_set_qos(ar);
-	} else
+	} else {
 		ret = -EINVAL;
+	}
 
 	mutex_unlock(&ar->mutex);
 	return ret;


