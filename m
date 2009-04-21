Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZDUNSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZDUNSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZDUNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:18:13 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37533 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZDUNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qhilul1q5BgEESKZNWNRj6RHd9voqOQOdNUU1nrv/Ct5EbLQhBw0/VjiDq8CeqNP7A
         hhal3VRSjxYfNhZt4aHGnw44GWW2egQ71xuIqx1P0oVtG7zTXwd8Ru1VMp54bkItQndT
         qPp49HKJwoVS3SFPtA0sBobEF1WFqKxbtpjhg=
Message-ID: <49EDC792.60100@gmail.com>
Date: Tue, 21 Apr 2009 15:18:10 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: staging: comedi: non working tests on unsigned cmd->convert_arg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/staging/comedi/comedi.h +342

and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned. Should there
maybe be a test:

if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)

(and what should MAX be then?)

Otherwise you may want to apply the cleanup patch below

Roel
------------------------------>8-------------8<---------------------------------
Remove redundant tests on unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..928c4c6 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1906,7 +1906,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
 		err++;
 	}
 
-	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
+	if (cmd->convert_src == TRIG_EXT) {
 		cmd->convert_arg = 0;
 		err++;
 	}
