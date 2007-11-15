Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXKOGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXKOGx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbXKOGqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57842 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762735AbXKOGqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:47 -0500
Date: Wed, 14 Nov 2007 22:44:11 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 06/40] hwmon/lm87: Disable VID when it should be
Message-ID: <20071115064411.GG19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-lm87-disable-vid-when-it-should-be.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=889af3d5d9586db795a06c619e416b4baee11da8

A stupid bit shifting bug caused the VID value to be always exported
even when the hardware is configured for something different.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm87.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -145,7 +145,7 @@ static u8 LM87_REG_TEMP_LOW[3] = { 0x3A,
 #define CHAN_NO_FAN(nr)		(1 << (nr))
 #define CHAN_TEMP3		(1 << 2)
 #define CHAN_VCC_5V		(1 << 3)
-#define CHAN_NO_VID		(1 << 8)
+#define CHAN_NO_VID		(1 << 7)
 
 /*
  * Functions declaration

-- 
