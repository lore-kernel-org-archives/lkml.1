Return-Path: <linux-kernel-owner+w=401wt.eu-S1765938AbXGYNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765938AbXGYNkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbXGYNkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:40:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760703AbXGYNkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:40:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: 2.6.23-rc1-mm1: chipsfb_pci_suspend problem
Date: Wed, 25 Jul 2007 15:48:10 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A7483C.60005@fr.ibm.com>
In-Reply-To: <46A7483C.60005@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251548.10962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 July 2007 14:55, Cedric Le Goater wrote:
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> 
> from pm-move-definition-of-struct-pm_ops-to-suspendh.patch :
> 
> drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
> drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
> drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
> drivers/video/chipsfb.c:461: error: for each function it appears in.)

Well, actually, this is a bug in chipsfb.c, as it shouldn't use PM_SUSPEND_MEM
in there, but PMSG_SUSPEND (patch untested).

Greetings,
Rafael


---
 drivers/video/chipsfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc1/drivers/video/chipsfb.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/video/chipsfb.c
+++ linux-2.6.23-rc1/drivers/video/chipsfb.c
@@ -458,7 +458,7 @@ static int chipsfb_pci_suspend(struct pc
 
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
-	if (state.event != PM_SUSPEND_MEM)
+	if (state != PMSG_SUSPEND)
 		goto done;
 
 	acquire_console_sem();
