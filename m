Return-Path: <linux-kernel-owner+w=401wt.eu-S939129AbXFHHod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939129AbXFHHod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938347AbXFHHYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:37 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:55619 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967794AbXFHHYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:34 -0400
Subject: Re: [PATCH 1/1] Watchdog driver for AT32AP700X devices
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Wim Van Sebroeck <wim@iguana.be>
In-Reply-To: <20070607160910.34d64842.akpm@linux-foundation.org>
References: <1181138647434-git-send-email-hcegtvedt@atmel.com>
	 <20070607160910.34d64842.akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-YR78brQj3/dMirmreQ2a"
Date: Fri, 08 Jun 2007 09:23:27 +0200
Message-Id: <1181287407.28296.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YR78brQj3/dMirmreQ2a
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-06-07 at 16:09 -0700, Andrew Morton wrote:
> On Wed,  6 Jun 2007 16:04:07 +0200
> Hans-Christian Egtvedt <hcegtvedt@atmel.com> wrote:
> 
> > This patch adds support for the built in watchdog in AT32AP700X devices.
> > 
> > Tested on AT32AP7000 and ATSTK1000.
> > 
> > Hardware documentation can be found in the AT32AP7000 datasheet.
> > 
> > ...
> >
> > +static int __init at32_wdt_probe(struct platform_device *pdev)
> > +{

<cut start of _probe>

> > +	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
> 
> I see an ioremap(), but there are no iounmap()s anywhere.

Hmm, that would be my fault, please see the attach patch, it should
apply clean to -mm after your two -fix{1,2} patches.

-- 
With kind regards,

Hans-Christian Egtvedt, siv.ing. (M.Sc.)
Applications Engineer - AVR32 System Solutions - Atmel Norway

--=-YR78brQj3/dMirmreQ2a
Content-Disposition: attachment; filename=0001-at32ap700x-wdt-add-missing-iounmap-in-_remove.txt
Content-Type: application/mbox; name=0001-at32ap700x-wdt-add-missing-iounmap-in-_remove.txt
Content-Transfer-Encoding: 7bit

>From 628847bb359162d2ea3a32a212f098406371119c Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date: Fri, 8 Jun 2007 08:04:43 +0200
Subject: [PATCH 1/1] at32ap700x-wdt: add missing iounmap in _remove

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
---
 drivers/char/watchdog/at32ap700x_wdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/watchdog/at32ap700x_wdt.c b/drivers/char/watchdog/at32ap700x_wdt.c
index 89fd9dc..56ace8c 100644
--- a/drivers/char/watchdog/at32ap700x_wdt.c
+++ b/drivers/char/watchdog/at32ap700x_wdt.c
@@ -257,6 +257,7 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 {
 	if (wdt && platform_get_drvdata(pdev) == wdt) {
 		misc_deregister(&wdt->miscdev);
+		iounmap(wdt->regs);
 		kfree(wdt);
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
-- 
1.4.4.2


--=-YR78brQj3/dMirmreQ2a--

