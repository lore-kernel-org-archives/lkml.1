Return-Path: <linux-kernel-owner+w=401wt.eu-S965252AbXHGVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252AbXHGVB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935470AbXHGUvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:51:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56324 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935569AbXHGUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:51:13 -0400
Date: Tue, 7 Aug 2007 13:45:32 -0700
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
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [2.6.22.2 review 31/84] V4L: wm8775/wm8739: Fix memory leak when
	unloading module
Message-ID: <20070807204532.GF23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-wm8775-wm8739-fix-memory-leak-when-unloading-module.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

State struct was never freed.

(cherry picked from commit 1b2232ab879993fcf5b9391c3febf6ab5d78201e)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/wm8739.c |    2 ++
 drivers/media/video/wm8775.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -321,12 +321,14 @@ static int wm8739_probe(struct i2c_adapt
 
 static int wm8739_detach(struct i2c_client *client)
 {
+	struct wm8739_state *state = i2c_get_clientdata(client);
 	int err;
 
 	err = i2c_detach_client(client);
 	if (err)
 		return err;
 
+	kfree(state);
 	kfree(client);
 	return 0;
 }
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -222,12 +222,14 @@ static int wm8775_probe(struct i2c_adapt
 
 static int wm8775_detach(struct i2c_client *client)
 {
+	struct wm8775_state *state = i2c_get_clientdata(client);
 	int err;
 
 	err = i2c_detach_client(client);
 	if (err) {
 		return err;
 	}
+	kfree(state);
 	kfree(client);
 
 	return 0;

-- 
