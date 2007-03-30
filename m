Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXC3VTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXC3VTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXC3VTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:19:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51560 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbXC3VLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:20 -0400
Date: Fri, 30 Mar 2007 14:05:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 21/37] V4L: radio: Fix error in Kbuild file
Message-ID: <20070330210553.GX29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-radio-fix-error-in-kbuild-file.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trent Piepho <xyzzy@speakeasy.org>

V4L: radio: Fix error in Kbuild file

All the radio drivers need video_dev, but they were depending on
VIDEO_DEV!=n.  That meant that one could try to compile the driver into
the kernel when VIDEO_DEV=m, which will not work.  If video_dev is a
module, then the radio drivers must be modules too.

(cherry picked from commit b10fece583fdfdb3d2f29b0da3896ec58b8fe122)

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Radio Adapters"
-	depends on VIDEO_DEV!=n
+	depends on VIDEO_DEV
 
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"

-- 
