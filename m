Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbYD3R6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbYD3R6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYD3R5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:57:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYD3R5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:57:51 -0400
Date: Wed, 30 Apr 2008 19:57:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch, -git] isdn: hysdn_procconf.c build fix
Message-ID: <20080430175740.GA26612@elte.hu>
References: <1207653508.7171.18.camel@iris.sw.ru> <1207653576-12640-25-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207653576-12640-25-git-send-email-den@openvz.org>
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


x86.git randconfig testing found the following build error in latest 
-git:

  CC [M]  drivers/isdn/hysdn/hysdn_procconf.o
  CC [M]  drivers/isdn/hysdn/hysdn_init.o
  drivers/isdn/hysdn/hysdn_procconf.c: In function 'hysdn_procconf_init':
  drivers/isdn/hysdn/hysdn_procconf.c:408: error: too few arguments to function 'proc_create'

with the following config:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_15_12_48_CEST_2008.bad

Ob'grumpy: this file was not even build-tested by any of the parties who 
turned it into upstream commit ac41cfd19b ("isdn: use non-racy method 
for proc entries creation").

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/isdn/hysdn/hysdn_procconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/isdn/hysdn/hysdn_procconf.c
===================================================================
--- linux.orig/drivers/isdn/hysdn/hysdn_procconf.c
+++ linux/drivers/isdn/hysdn/hysdn_procconf.c
@@ -405,7 +405,8 @@ hysdn_procconf_init(void)
 		sprintf(conf_name, "%s%d", PROC_CONF_BASENAME, card->myid);
 		if ((card->procconf = (void *) proc_create(conf_name,
 						S_IFREG | S_IRUGO | S_IWUSR,
-						hysdn_proc_entry)) != NULL) {
+						hysdn_proc_entry,
+						&conf_fops)) != NULL) {
 			hysdn_proclog_init(card);	/* init the log file entry */
 		}
 		card = card->next;	/* next entry */
