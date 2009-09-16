Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZIPTrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZIPTrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZIPTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:47:05 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46307 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbZIPTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:47:04 -0400
Date: Wed, 16 Sep 2009 21:51:56 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090916195156.GA30867@electric-eye.fr.zoreil.com>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de> <200909152148.29662.oliver@neukum.org> <20090916181910.GA28260@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916181910.GA28260@rhlx01.hs-esslingen.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr <andi@lisas.de> :
[...]
> Anyway, doesn't change the fact that the r8169 WOL PHY setting is toast
> after every S2R as well ;)

Stealth tester, he ?

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 50c6a3c..e0af22f 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3962,8 +3962,7 @@ static int rtl8169_resume(struct device *device)
 		goto out;
 
 	netif_device_attach(dev);
-
-	rtl8169_schedule_work(dev, rtl8169_reset_task);
+	netif_wake_queue(dev);
 out:
 	return 0;
 }

-- 
Ueimor
