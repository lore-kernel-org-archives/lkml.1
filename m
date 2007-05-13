Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbXEMXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbXEMXcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXEMXcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:32:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52321 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbXEMXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:32:04 -0400
X-IronPort-AV: i="4.14,527,1170662400"; 
   d="scan'208"; a="148413773:sNHT41233347"
To: David Miller <davem@davemloft.net>
Cc: tilman@imap.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc1
X-Message-Flag: Warning: May contain useful information
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<4647569D.7010709@imap.cc>
	<20070513.162059.78710763.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 13 May 2007 16:32:00 -0700
In-Reply-To: <20070513.162059.78710763.davem@davemloft.net> (David Miller's message of "Sun, 13 May 2007 16:20:59 -0700 (PDT)")
Message-ID: <ada3b20xpu7.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2007 23:32:01.0231 (UTC) FILETIME=[E800EDF0:01C795B6]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Would it be asking too much to have help texts on the following
 > > new (wrt 2.6.21) configuration options?
 > > 
 > > ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
 > 
 > This one is a case where the option makes no sense by itself,
 > it provides the core common code for other front-end drivers.
 > 
 > The documentation exists in those front end drivers, which
 > in turn auto-matically select and enable this config option.
 > 
 > It would be nice if there was a Kconfig way to not provide
 > this thing at all unless one of the front-ends got selected
 > but on the otherhand I like how anyone can select it and thus
 > test the build of it :-)

If this is just an internal option that people shouldn't have to deal
with, why have a prompt at all?  AFAIK the following (untested) patch
should do exactly what you want.

FWIW:
Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e62d23f..5366913 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1754,7 +1754,7 @@ config SUN3X_ESP
 	  machines.  Say Y here to compile in support for it.
 
 config SCSI_ESP_CORE
-	tristate "ESP Scsi Driver Core"
+	tristate
 	depends on SCSI
 	select SCSI_SPI_ATTRS
 
