Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXJON4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXJON4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXJON4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:56:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44059 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbXJON4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:56:44 -0400
Date: Mon, 15 Oct 2007 15:56:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] ssb: fix build failure
Message-ID: <20071015135632.GA31579@elte.hu>
References: <20071014032948.GA25760@elte.hu> <20071014033549.GQ8181@ftp.linux.org.uk> <20071015105344.GA17028@elte.hu> <200710151458.54817.mb@bu3sch.de> <20071015135041.GB30221@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015135041.GB30221@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> have triggered a new SSB build failure meanwhile:
> 
> drivers/built-in.o: In function `ssb_pcmcia_switch_coreidx':
> : undefined reference to `pcmcia_access_configuration_register'

the patch below fixes it for me. PCI seems to have a similar bug as 
well.

	Ingo

----------------->
Subject: ssb: fix build failure
From: Ingo Molnar <mingo@elte.hu>

fix build failure if PCMCIA=m but SSB=y:

drivers/built-in.o: In function `ssb_pcmcia_switch_coreidx':
: undefined reference to `pcmcia_access_configuration_register'

(fix symmetric bug for PCI too.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/ssb/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/ssb/Kconfig
===================================================================
--- linux.orig/drivers/ssb/Kconfig
+++ linux/drivers/ssb/Kconfig
@@ -22,7 +22,7 @@ config SSB
 
 config SSB_PCIHOST_POSSIBLE
 	bool
-	depends on SSB && PCI
+	depends on SSB && (PCI = SSB)
 	default y
 
 config SSB_PCIHOST
@@ -37,7 +37,7 @@ config SSB_PCIHOST
 
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
-	depends on SSB && PCMCIA && EXPERIMENTAL
+	depends on SSB && (PCMCIA = SSB) && EXPERIMENTAL
 	default y
 
 config SSB_PCMCIAHOST
