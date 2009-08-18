Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbZHRPFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbZHRPFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbZHRPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:05:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759195AbZHRPFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:05:21 -0400
Date: Tue, 18 Aug 2009 17:05:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Jesper Nilsson <jesper.nilsson@axis.com>,
       Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH] [PATCH] CRIS: fix defconfig build failure
Message-ID: <20090818150514.GA12868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CRIS defconfig fails to build with:

  drivers/serial/crisv10.c: In function 'rs_wait_until_sent':
  drivers/serial/crisv10.c:3926: error: implicit declaration of function 'lock_kernel'
  drivers/serial/crisv10.c:3943: error: implicit declaration of function 'unlock_kernel'

Include smp_lock.h.

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/serial/crisv10.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 7be52fe..31f1723 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -18,6 +18,7 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/major.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
