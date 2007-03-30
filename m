Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbXC3VQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbXC3VQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXC3VMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbXC3VLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:31 -0400
Date: Fri, 30 Mar 2007 14:06:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 23/37] V4L: msp_attach must return 0 if no msp3400 was
	found.
Message-ID: <20070330210620.GZ29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-msp_attach-must-return-0-if-no-msp3400-was-found.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hans Verkuil <hverkuil@xs4all.nl>

V4L: msp_attach must return 0 if no msp3400 was found.

Returning -1 causes the probe to stop, but it should just continue
instead. This patch fixes an annoying 'i2c_adapter i2c-7: Client
creation failed at 0x44 (-1)' kernel message that appeared in 2.6.20

(cherry picked from commit 3284b4e077cb2322754ea7455b8f8af7ce3777b8)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/msp3400-driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -825,7 +825,7 @@ static int msp_attach(struct i2c_adapter
 	if (msp_reset(client) == -1) {
 		v4l_dbg(1, msp_debug, client, "msp3400 not found\n");
 		kfree(client);
-		return -1;
+		return 0;
 	}
 
 	state = kmalloc(sizeof(*state), GFP_KERNEL);
@@ -859,7 +859,7 @@ static int msp_attach(struct i2c_adapter
 		v4l_dbg(1, msp_debug, client, "not an msp3400 (cannot read chip version)\n");
 		kfree(state);
 		kfree(client);
-		return -1;
+		return 0;
 	}
 
 	msp_set_audio(client);

-- 
