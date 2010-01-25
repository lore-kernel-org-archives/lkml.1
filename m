Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514Ab0AYKXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0AYKXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229Ab0AYKXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:23:11 -0500
Received: from blu0-omc1-s27.blu0.hotmail.com ([65.55.116.38]:11293 "EHLO
	blu0-omc1-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab0AYKXK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:23:10 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 05:23:10 EST
Message-ID: <BLU108-W259018EFE8CC5014C4C1829C5F0@phx.gbl>
X-Originating-IP: [87.81.120.187]
From: d binderman <dcb314@hotmail.com>
To: <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] RE: Linux kernel 2.6.33-rc5 bug report
Date: Mon, 25 Jan 2010 10:16:55 +0000
Importance: Normal
In-Reply-To: <20100125060850.GA23232@suse.de>
References: <BLU108-W6FFE536027D1D0125666D9C600@phx.gbl>,<20100125060850.GA23232@suse.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Jan 2010 10:16:55.0116 (UTC) FILETIME=[851278C0:01CA9DA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello there,

Greg wrote:
> Care to make up a patch to fix this issue? 

Here is an untested trivial patch to fix a memory leak in Linux kernel
2.6.33-rc5 directory drivers/staging/otus

From:  David Binderman <dcb314@hotmail.com>

Fix memory leak in drivers/staging/otus

Signed-off-by: David Binderman <dcb314@hotmail.com>

---


--- drivers/staging/otus/ioctl.c.sav    2010-01-25 09:45:30.000000000 +0000
+++ drivers/staging/otus/ioctl.c        2010-01-25 09:55:56.000000000 +0000
@@ -866,15 +866,15 @@ int usbdrvwext_giwscan(struct net_device
        char *current_ev = extra;
        char *end_buf;
        int i;
-       /* struct zsBssList BssList; */
-       struct zsBssListV1 *pBssList = kmalloc(sizeof(struct zsBssListV1),
-                                                               GFP_KERNEL);
        /* BssList = wd->sta.pBssList; */
        /* zmw_get_wlan_dev(dev); */

        if (macp->DeviceOpened != 1)
                return 0;

+       /* struct zsBssList BssList; */
+       struct zsBssListV1 *pBssList = kmalloc(sizeof(struct zsBssListV1),
+                                                               GFP_KERNEL);
        if (data->length == 0)
                end_buf = extra + IW_SCAN_MAX_DATA;
        else



 		 	   		  
_________________________________________________________________
We want to hear all your funny, exciting and crazy Hotmail stories. Tell us now
http://clk.atdmt.com/UKM/go/195013117/direct/01/