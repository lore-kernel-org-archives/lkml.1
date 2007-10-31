Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXJaP3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXJaP3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbXJaPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:25:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33642 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825AbXJaPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:25:08 -0400
Date: Wed, 31 Oct 2007 08:12:12 -0700
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
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: [patch 21/26] hwmon/lm87: Fix a division by zero
Message-ID: <20071031151212.GV2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-lm87-fix-a-division-by-zero.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b965d4b7f614522170af6a7e450be0333792ccd2

Missing parentheses in the definition of FAN_FROM_REG cause a
division by zero for a specific register value.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Hans de Goede <j.w.r.degoede@hhs.nl>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm87.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -129,7 +129,7 @@ static u8 LM87_REG_TEMP_LOW[3] = { 0x3A,
 				 (((val) < 0 ? (val)-500 : (val)+500) / 1000))
 
 #define FAN_FROM_REG(reg,div)	((reg) == 255 || (reg) == 0 ? 0 : \
-				 1350000 + (reg)*(div) / 2) / ((reg)*(div))
+				 (1350000 + (reg)*(div) / 2) / ((reg)*(div)))
 #define FAN_TO_REG(val,div)	((val)*(div) * 255 <= 1350000 ? 255 : \
 				 (1350000 + (val)*(div) / 2) / ((val)*(div)))
 

-- 
