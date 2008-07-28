Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbYG1Wg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbYG1Wg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG1WgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:36:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYG1WgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:36:17 -0400
Date: Tue, 29 Jul 2008 00:35:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Sterba <dsterba@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-net@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [resend] [PATCH] Build fallout from scsi merge...
Message-ID: <20080728223557.GA26416@elte.hu>
References: <1217283104.3503.170.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217283104.3503.170.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> There's a brown paper bag compile failure introduced by this patch

hm, while at it, i still dont see the scsi build fix below upstream. My 
tests were hit by it too.

	Ingo

------------------->
>From c3d4eb8e157b6e4bb0b87e921bb5743cfc6f8f25 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 28 Jul 2008 11:59:20 +0900
Subject: [PATCH] Build fallout from scsi merge...

On Sun, 27 Jul 2008 17:04:15 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

>
> From allmodconfig on sparc64:
>
> drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
> drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
> make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
> make[3]: *** Waiting for unfinished jobs....

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] qla2xxx: fix msleep compile error

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
make[3]: *** Waiting for unfinished jobs....

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: davem@davemloft.net
Cc: James.Bottomley@HansenPartnership.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7a4409a..a319a20 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
