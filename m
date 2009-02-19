Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZBSKgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZBSKgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZBSKgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:36:44 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47328 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZBSKgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=wA9raXcaRrH0Q/15hvytRv6RXMC17ld8564FT2iBVw0De3Yvf9637AC/nmuEUJ9Oix
         fP8kJ3ZxIFUpZsiJgDlR66RBWLjEUrhIHVC2OXmHnKfgaWLIa4OoV5HVRJT2hXuH3O2Z
         WfhG9RnBpxs0PRy/9WLAfyDgm+i7rEvIFNUWw=
Message-ID: <499D3639.3080109@gmail.com>
Date: Thu, 19 Feb 2009 11:36:41 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: ! x & y problem in inactive code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only ! x & y problem I found that weren't already reported,
except by me in http://lkml.org/lkml/2009/1/17/69 but maybe you
overlooked it?

It's in comment, but maybe this was the reason why it was commented out to
begin with?

Gr,

Roel
--------------------------->8-------------8<------------------------------
Fix ! x & y problem in inactivated code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 9453495..18a7bad 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3161,7 +3161,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 		return ;
 
 	}
-	//while(! *tail & (1<<31)){
+	//while(! (*tail & (1<<31))){
 		*tail= 0; // zeroes header
 
 		*tail = *tail| (1<<29) ; //fist segment of the packet
