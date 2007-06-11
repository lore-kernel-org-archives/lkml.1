Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbXFKE5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbXFKE5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 00:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXFKE5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 00:57:43 -0400
Received: from mx-out.forthnet.gr ([193.92.150.103]:57437 "EHLO
	mx-out-01.forthnet.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXFKE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 00:57:43 -0400
X-Greylist: delayed 2939 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 00:57:42 EDT
Authentication-Results: MX-IN-04.forthnet.gr smtp.mail=mmargaron@gmail.com; spf=neutral
Authentication-Results: MX-IN-04.forthnet.gr header.from=mmargaron@gmail.com; sender-id=neutral
Date: Mon, 11 Jun 2007 07:12:32 +0300 (EEST)
From: Miltiadis Margaronis <mmargaron@gmail.com>
X-X-Sender: miltux@micmac.localdomain
To: dmitry.torokhov@gmail.com
cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: [PATCH] input: make 2 macros in gameport.c TSC-aware
Message-ID: <alpine.BSF.0.99.0706110624150.5014@micmac.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  This makes DELTA and GET_TIME in drivers/input/gameport/gameport.c
  similar to the ones in drivers/input/joystick/analog.c . Worked on
  2.6.22-rc4-git2.

Signed-off-by: Miltiadis Margaronis <mmargaron@gmail.com>


--- a/drivers/input/gameport/gameport.c	2007-06-05 03:57:02.000000000 +0300
+++ b/drivers/input/gameport/gameport.c	2007-06-09 07:20:45.000000000 +0300
@@ -64,8 +64,8 @@ static void gameport_disconnect_port(str

  #include <asm/i8253.h>

-#define DELTA(x,y)      ((y)-(x)+((y)<(x)?1193182/HZ:0))
-#define GET_TIME(x)     do { x = get_time_pit(); } while (0)
+#define DELTA(x,y)      (cpu_has_tsc ? ((y) - (x)) : ((y) - (x) +((y) < (x) ? CLOCK_TICK_RATE / HZ : 0)))
+#define GET_TIME(x)     do { if (cpu_has_tsc) rdtscl(x); else x = get_time_pit(); } while (0)

  static unsigned int get_time_pit(void)
  {

-- 
Miltos

