Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZGTKsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZGTKsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZGTKst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:48:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZGTKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:48:48 -0400
Date: Mon, 20 Jul 2009 12:47:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090720104726.GE19341@elf.ucw.cz>
References: <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <20090714094629.GB2076@elf.ucw.cz> <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com> <20090714221638.GA6512@elf.ucw.cz> <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com> <20090719212330.GI26511@elf.ucw.cz> <d6200be20907192043w3f1aa2abvd0125163e6f5519c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20907192043w3f1aa2abvd0125163e6f5519c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

You probably want (something like) this to mostly fix !EARLY_SUSPEND
compilation.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

index a45634b..e916cea 100644
--- a/drivers/staging/dream/synaptics_i2c_rmi.c
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -45,7 +44,9 @@ struct synaptics_ts_data {
 	int snap_up[2];
 	uint32_t flags;
 	int (*power)(int on);
+#ifdef CONFIG_HAS_EARLYSUSPEND
 	struct early_suspend early_suspend;
+#endif
 };
 
 #ifdef CONFIG_HAS_EARLYSUSPEND
@@ -515,7 +516,9 @@ err_check_functionality_failed:
 static int synaptics_ts_remove(struct i2c_client *client)
 {
 	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
+#ifdef CONFIG_HAS_EARLYSUSPEND
 	unregister_early_suspend(&ts->early_suspend);
+#endif
 	if (ts->use_irq)
 		free_irq(client->irq, ts);
 	else


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
