Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYGaTNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYGaTNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYGaTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:13:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbYGaTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:13:17 -0400
Date: Thu, 31 Jul 2008 12:13:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rjw@sisk.pl, bzolnier@gmail.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: Tree for July 30
Message-Id: <20080731121308.bfbdcd0d.akpm@linux-foundation.org>
In-Reply-To: <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
	<20080731104437.5e5669bc.akpm@linux-foundation.org>
	<20080731141302.ZZRA012@mailhub.coreip.homeip.net>
	<200807312048.57575.rjw@sisk.pl>
	<20080731145023.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 14:54:52 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > IOW, if the change responsible for this makes it to the mainline kernel, it
> > will be considered as a regression.
> > 
> 
> Like I said, I don't agree.

It really really doesn't matter what the causes are or which piece of
code is at fault or anything else like that.

What _does_ matter is that people's stuff will break.  Apparently lots
of people's.  That's a problem.  A _practical_ problem.  Can we
pleeeeeeze be practical and find some way of preventing it?

I assume this is the commit?


commit 03bac96fae0efdb25e2059e5accbe4f3ee6328dd
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Jun 23 10:47:34 2008 -0400

    Input: expand keycode space
    
    Expand the number of potential key codes from 512 to 768 since people
    are coming up with more and more keys.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

diff --git a/include/linux/input.h b/include/linux/input.h
index a5802c9..7fae1de 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -579,7 +579,7 @@ struct input_absinfo {
 
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
-#define KEY_MAX			0x1ff
+#define KEY_MAX			0x2ff
 #define KEY_CNT			(KEY_MAX+1)
 
 /*
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index c4db582..0dddfa4 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -274,7 +274,7 @@ struct pcmcia_device_id {
 /* Input */
 #define INPUT_DEVICE_ID_EV_MAX		0x1f
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
-#define INPUT_DEVICE_ID_KEY_MAX		0x1ff
+#define INPUT_DEVICE_ID_KEY_MAX		0x2ff
 #define INPUT_DEVICE_ID_REL_MAX		0x0f
 #define INPUT_DEVICE_ID_ABS_MAX		0x3f
 #define INPUT_DEVICE_ID_MSC_MAX		0x07


I'm unable to work out how necessary this change is?


Please: what proportion of the existing X installations do you expect will
be affected by this?

