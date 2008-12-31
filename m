Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYLaRuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYLaRuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYLaRuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:50:35 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:35563 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756098AbYLaRue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:50:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=25zMqcOnjZ5WvFo9OfERuy1k8TsmyhPV4mOrG3q8+CVlZz9RzlnYSGTI4YB4UQYoLLog9TIxxxOvrrZg37mxp8Z7J2nrSEAhQlK2+HLT0+UnNy6DpOswbBgpv8frDuoJXqQ3ufeMNcmlphPu+oct4jVKv/bBlYoDM6AVO2c/vQ0=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.28] mmc: warn about voltage mismatches
Date: Wed, 31 Dec 2008 09:50:30 -0800
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812310950.30478.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Get rid of a silent failure mode when the MMC/SD host doesn't
support the voltages needed to operate a given card, by
adding a warning.  A 3.3V host and a 3.0V card, for example,
no longer need to mysteriously just not work at all.

This isn't the best diagnostic; ideally it would also tell
what voltage the card and host support (and not just by
dumping the bitmasks).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mmc/core/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -467,6 +467,8 @@ u32 mmc_select_voltage(struct mmc_host *
 		host->ios.vdd = bit;
 		mmc_set_ios(host);
 	} else {
+		pr_warning("%s: host doesn't support card's voltages\n",
+				mmc_hostname(host));
 		ocr = 0;
 	}
 
