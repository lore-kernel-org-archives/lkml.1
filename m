Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXE3OJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXE3OJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbXE3OJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:09:23 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37711 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbXE3OJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:09:21 -0400
Date: Wed, 30 May 2007 16:08:14 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: i8042 - cleanup of debug code (was Re: 2.6.22-rc2-mm1)
In-Reply-To: <200705232328.42657.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0705301603200.10318@twin.jikos.cz>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <1179962229.8575.4.camel@localhost> <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
 <200705232328.42657.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(some irrelevant CCs dropped)

On Wed, 23 May 2007, Dmitry Torokhov wrote:

> It looks like you are now in the same position I was some time ago WRT 
> to debug information for i8042 - constantly asking people to enable 
> debug, recompile and send the results. May I recommend changing 
> CONFIG_HID_DEBUG to "default y if !EMBEDDED" and controlling debug 
> output via a module parameter? -ENOPATCH though...

Hi Dmitry,

I have just queued corresponding patch in HID tree.

BTW when looking at the i8042 code I have just noticed that the trivial 
cleanup below could be possible.



From: Jiri Kosina <jkosina@suse.cz>

Input: i8042 - cleanup of debug code
    
Debugging facility of i8042 is now toggled in runtime instead
of needing to recompile the kernel. Therefore the DEBUG macro
is useless (it's hardcoded to be defined anyway). Remove it.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 3888dc3..5c3405d 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -69,12 +69,9 @@ module_param_named(nopnp, i8042_nopnp, b
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
 #endif
 
-#define DEBUG
-#ifdef DEBUG
 static int i8042_debug;
 module_param_named(debug, i8042_debug, bool, 0600);
 MODULE_PARM_DESC(debug, "Turn i8042 debugging mode on and off");
-#endif
 
 #include "i8042.h"
 
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index b3eb7a7..eec4b32 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -106,7 +106,6 @@
  * Debug.
  */
 
-#ifdef DEBUG
 static unsigned long i8042_start_time;
 #define dbg_init() do { i8042_start_time = jiffies; } while (0)
 #define dbg(format, arg...) 							\
@@ -115,9 +114,4 @@ static unsigned long i8042_start_time;
 			printk(KERN_DEBUG __FILE__ ": " format " [%d]\n" ,	\
 	 			## arg, (int) (jiffies - i8042_start_time));	\
 	} while (0)
-#else
-#define dbg_init() do { } while (0)
-#define dbg(format, arg...) do {} while (0)
-#endif
-
 #endif /* _I8042_H */
