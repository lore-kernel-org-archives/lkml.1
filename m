Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXBEDT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXBEDT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 22:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXBEDT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 22:19:27 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37299 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbXBEDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 22:19:26 -0500
Message-ID: <45C6A23A.8010305@lwfinger.net>
Date: Sun, 04 Feb 2007 21:19:22 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bcm43xx-dev@lists.berlios.de,
       roucaries bastien <roucaries.bastien@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Bcm43xx oops after suspend to disk
References: <45B92488.6090908@lwfinger.net>	<195c7a900702040907y8b8eff0gc8b0bbddd79a6792@mail.gmail.com>	<45C61B09.7010102@lwfinger.net> <200702050210.06009.rjw@sisk.pl>
In-Reply-To: <200702050210.06009.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 4 February 2007 18:42, Larry Finger wrote:
>> roucaries bastien wrote:
>>> Sorry for the delay it works. This time I can use iwlist eth scan.
>>> I have some difficulties to associate and I need to rmmod/modprobe in
>>> order to associate but it is another problem linked to a really weak
>>> power.
>> Bastien,
>>
>> Please try this patch instead.
> 
> Hm, it doesn't seem to apply to the mainline version of the driver.  Any chance
> for a fix against 2.6.20?

Please try this one. I forgot about some other stuff in my working copy of wireless-2.6.

Larry

============

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3617,6 +3617,7 @@ error:
 static int bcm43xx_init_board(struct bcm43xx_private *bcm)
 {
 	int err;
+	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);

 	mutex_lock(&(bcm)->mutex);

@@ -3637,6 +3638,8 @@ static int bcm43xx_init_board(struct bcm
 	if (err)
 		goto err_sysfs_unreg;
 	bcm43xx_periodic_tasks_setup(bcm);
+	/* force initial LO calibration */
+	phy->lo_control->txctl2 = 0xFFFF;

 	/*FIXME: This should be handled by softmac instead. */
 	schedule_delayed_work(&bcm->softmac->associnfo.work, 0);
