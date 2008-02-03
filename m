Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbYBCEzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbYBCEzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 23:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYBCEy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 23:54:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59088 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbYBCEyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 23:54:55 -0500
Date: Sun, 3 Feb 2008 05:54:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [patch] scsi: fix spurious build failures in aic7xxx
Message-ID: <20080203045441.GA12128@elte.hu>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu> <20080202162611.GA24765@uranus.ravnborg.org> <20080202171020.GB12748@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202171020.GB12748@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I could not reproduce the bug myself but I think I spotted it. We 
> > had a missing dependency to the _reg.h file. Try following patch and 
> > let me now if it continue to break.
> 
> thanks! I threw this into the test setup and will know by tomorrow 
> whether there's any breakage.

good news: hundreds of successful kernel builds and no failures 
overnight. I've Cc:-ed the aic7xxx people.

	Ingo

------------------->
Subject: scsi: fix spurious build failures in aic7xxx
From: Sam Ravnborg <sam@ravnborg.org>

We had a missing dependency to the _reg.h file.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/aic7xxx/Makefile |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux/drivers/scsi/aic7xxx/Makefile
===================================================================
--- linux.orig/drivers/scsi/aic7xxx/Makefile
+++ linux/drivers/scsi/aic7xxx/Makefile
@@ -44,13 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg
 
 # Dependencies for generated files need to be listed explicitly
 
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_reg.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_reg.h
-
-$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h
-$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h
+$(addprefix $(obj)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(obj)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
 aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c
