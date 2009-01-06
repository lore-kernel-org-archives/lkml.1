Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZAFRgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZAFRgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZAFRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:36:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:54879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZAFRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:36:21 -0500
Date: Tue, 6 Jan 2009 17:36:09 +0000 (GMT)
From: Alexey Korolev <akorolev@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Vasiliy Leonenko <vasiliy.leonenko@gmail.com>
Subject: Re: linux-next: Tree for January 6 (MTD)
In-Reply-To: <496386DB.8090606@oracle.com>
Message-ID: <alpine.LFD.2.00.0901061632590.4300@casper.infradead.org>
References: <20090106182311.525e4b14.sfr@canb.auug.org.au> <496386DB.8090606@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_QINFO_PROBE=y
> 
> There appears to be too little control/coordination between those
> two kconfig symbols.  Surely one of them (MTD_QINFO_PROBE) should
> depend on the other (MTD_LPDDR).  And why even build 2 modules
> when MTD_QINFO_PROBE is enabled?  Why not combine the code into
> one module?
Thanks a lot for good finding. Here is a fix for the problem.

About combining: it is assumed to have one QINFO probing module for several
kinds of LPDDR command set drivers. If we combine two modules into
one it would make further extension rather hard. So it is better to have
two modules.
To fix a problem I just added dependency in Kconfig file.
This temporary fix which will work until we have just one cmdset module.
In near future we will make a fix which parse command set types
 and select proper driver according to device type.

Thanks,
Alexey

Signed-off-by: Alexey Korolev <akorolev@infradead.org>
---
diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
index acd4ea9..5a401d8 100644
--- a/drivers/mtd/lpddr/Kconfig
+++ b/drivers/mtd/lpddr/Kconfig
@@ -12,6 +12,7 @@ config MTD_LPDDR
 	  DDR memories, intended for battery-operated systems.
 
 config MTD_QINFO_PROBE
+	depends on MTD_LPDDR
 	tristate "Detect flash chips by QINFO probe"
 	help
 	    Device Information for LPDDR chips is offered through the Overlay


