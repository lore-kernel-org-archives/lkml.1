Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXILCLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXILCLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXILCLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:11:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56569 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbXILCLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:11:10 -0400
Date: Wed, 12 Sep 2007 11:11:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] ssb: Make pcmciahost depend on PCMCIA=y
Message-ID: <20070912021100.GB26827@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SSB uses a bool (SSB_PCMCIAHOST_POSSIBLE) to determine whether to
build in PCMCIA support or not, as the PCMCIA host code itself is
also only a bool, make SSB_PCMCIAHOST_POSSIBLE depend on PCMCIA=y.

Without this, SSB_PCMCIAHOST_POSSIBLE evaluates to y when PCMCIA
is built as a module, which results in link errors due to the
pcmcia_access_configuration_register() accesses, where the symbol
is only defined in a module.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/ssb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1.orig/drivers/ssb/Kconfig	2007-09-11 15:15:52.000000000 +0900
+++ linux-2.6.23-rc4-mm1/drivers/ssb/Kconfig	2007-09-12 10:51:53.000000000 +0900
@@ -37,7 +37,7 @@
 
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
-	depends on SSB && PCMCIA && EXPERIMENTAL
+	depends on SSB && PCMCIA=y && EXPERIMENTAL
 	default y
 
 config SSB_PCMCIAHOST
