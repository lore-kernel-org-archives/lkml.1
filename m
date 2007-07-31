Return-Path: <linux-kernel-owner+w=401wt.eu-S969492AbXGaEkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969492AbXGaEkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbXGaEcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34751 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967704AbXGaEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:53 -0400
Date: Mon, 30 Jul 2007 21:34:05 -0700
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
       v4l-dvb-maintainer@linuxtv.org, jelle@foks.8m.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 26/26] V4L: cx88-blackbird: fix vidioc_g_tuner never ending
	list of tuners
Message-ID: <20070731043405.GA3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx88-blackbird-fix-vidioc_g_tuner-never-ending-list-of-tuners.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jelle Foks <jelle@foks.8m.com>

v4l-info and other programs would loop indefinitely while querying the
tuners for cx88-blackbird cards.

The cause was that vidioc_g_tuner didn't return an error value for
qctrl->id != 0, making the application think there is a never ending
list of tuners...

This patch adds the same index check as done in vidioc_g_tuner() in
cx88-video.

Signed-off-by: Jelle Foks <jelle@foks.8m.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
(cherry picked from commit f057131fb6eb2c45f6023e3da41ccd6e4e71aee9)

 drivers/media/video/cx88/cx88-blackbird.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21.6.orig/drivers/media/video/cx88/cx88-blackbird.c
+++ linux-2.6.21.6/drivers/media/video/cx88/cx88-blackbird.c
@@ -1034,6 +1034,8 @@ static int vidioc_g_tuner (struct file *
 
 	if (unlikely(UNSET == core->tuner_type))
 		return -EINVAL;
+	if (0 != t->index)
+		return -EINVAL;
 
 	strcpy(t->name, "Television");
 	t->type       = V4L2_TUNER_ANALOG_TV;

-- 
