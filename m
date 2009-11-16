Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZKPEU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZKPEU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZKPESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZKPESx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NrwkduPSYdggv1MrE0P6FWjgog/6agD/ZEOn+sTtCSDctJ9ZO+5mu0hbktWtEx5Lpx
         eiER8UXI/sku4Pi2S2zqALlEsNKPAEdgHJzwqfmA8pvSPP0VvaV3qQd4Va8SFvpXQupG
         zZasIukEixdTYIJpZDGIO1olFuB96/ioCl+OU=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 07/13] staging: line6: Convert simple_strtoul() to strict_strtoul in control.c
Date: Sun, 15 Nov 2009 22:17:56 -0600
Message-Id: <1258345082-11811-8-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/control.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
index 2d98935..0b59852 100644
--- a/drivers/staging/line6/control.c
+++ b/drivers/staging/line6/control.c
@@ -56,7 +56,13 @@ static ssize_t pod_set_param_int(struct device *dev, const char *buf,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int retval;
+
+	retval = strict_strtoul(buf, 10, &value);
+	if (retval)
+		return retval;
+
 	pod_transmit_parameter(pod, param, value);
 	return count;
 }
-- 
1.6.5

