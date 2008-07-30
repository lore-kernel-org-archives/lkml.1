Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYGaAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYGaAXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763330AbYGaAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:21:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763181AbYGaAVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:21:44 -0400
Date: Wed, 30 Jul 2008 16:59:37 -0700
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
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 47/62] DVB: cx23885: Ensure PAD_CTRL is always reset to a
	sensible default
Message-ID: <20080730235937.GU12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-cx23885-ensure-pad_ctrl-is-always-reset-to-a-sensible-default.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit ecda5966c90746a044ff68e78b1062adcddd9664)

DVB: cx23885: Ensure PAD_CTRL is always reset to a sensible default

PAD_CTRL controls TS1 and TS2 input and output states, if the
register became corrupt the driver was never able to recover.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -460,6 +460,7 @@ static void cx23885_reset(struct cx23885
 	cx_write(AUDIO_INT_INT_STAT, 0xffffffff);
 	cx_write(AUDIO_EXT_INT_STAT, 0xffffffff);
 	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
+	cx_write(PAD_CTRL, 0x00500300);
 
 	mdelay(100);
 

-- 
