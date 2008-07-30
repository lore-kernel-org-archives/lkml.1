Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbYGaAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbYGaAXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763148AbYGaAVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:21:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:37408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762709AbYGaAVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:21:23 -0400
Date: Wed, 30 Jul 2008 16:59:31 -0700
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
Subject: [patch 46/62] V4L: cx23885: Bugfix for concurrent use of
	/dev/video0 and /dev/video1
Message-ID: <20080730235931.GT12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx23885-bugfix-for-concurrent-use-of-dev-video0-and-dev-video1.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit 28901ab621bb56cd2aa9670dc7ce016ba80ec45c)

V4L: cx23885: Bugfix for concurrent use of /dev/video0 and /dev/video1

With the HVR1800, trying to use video0 and video1 simultaneously
caused buffer corruption in the PCIe bridge. This fix reallocates
video1 buffer locations to avoid the issue.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -104,8 +104,8 @@ static struct sram_channel cx23887_sram_
 	[SRAM_CH03] = {
 		.name		= "TS1 B",
 		.cmds_start	= 0x100A0,
-		.ctrl_start	= 0x10780,
-		.cdt		= 0x10400,
+		.ctrl_start	= 0x10670,
+		.cdt		= 0x10810,
 		.fifo_start	= 0x5000,
 		.fifo_size	= 0x1000,
 		.ptr1_reg	= DMA3_PTR1,

-- 
