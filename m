Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZDUNWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZDUNWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZDUNWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:22:30 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63942 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZDUNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FNHB3jwc2AcyLRjI6i26ofwUC5lFJhNC60kTQ1O+FaNCATRlKdeKt9FjhOYpoUEdHV
         ahtKzxIi3z3hjqkMT7lhc0I8wMb8uleLegLJACMKCPceeXfXJ/A9zhA3g+unWAXn8A/6
         hKr6/8PfiL9kaxg2SDdB1fv+wL6XdeHb8HAvE=
Message-ID: <49EDC893.9040104@gmail.com>
Date: Tue, 21 Apr 2009 15:22:27 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: staging: comedi: non working tests on unsigned cmd->convert_arg
References: <49EDC792.60100@gmail.com>
In-Reply-To: <49EDC792.60100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> vi drivers/staging/comedi/comedi.h +342
> 
> and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned. Should there
> maybe be a test:
> 
> if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)
> 
> (and what should MAX be then?)

The same question for cmd->scan_begin_arg and cmd->start_arg.

Otherwise you may want to apply the cleanup patch below
------------------------------>8-------------8<---------------------------------
Remove redundant tests on unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..637b0f1 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1886,7 +1886,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
 		err++;
 	}
 
-	if (cmd->start_src == TRIG_EXT && cmd->start_arg < 0) {
+	if (cmd->start_src == TRIG_EXT) {
 		cmd->start_arg = 0;
 		err++;
 	}
@@ -1896,7 +1896,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
 		err++;
 	}
 
-	if (cmd->scan_begin_src == TRIG_EXT && cmd->scan_begin_arg < 0) {
+	if (cmd->scan_begin_src == TRIG_EXT) {
 		cmd->scan_begin_arg = 0;
 		err++;
 	}
@@ -1906,7 +1906,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
 		err++;
 	}
 
-	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
+	if (cmd->convert_src == TRIG_EXT) {
 		cmd->convert_arg = 0;
 		err++;
 	}

