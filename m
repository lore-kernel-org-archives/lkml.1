Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbXLVN7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbXLVN7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXLVN6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:58:55 -0500
Received: from langos.euedge.com ([209.190.22.130]:42195 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXLVN6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:58:54 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 08:58:54 EST
Message-ID: <476D15EC.8010309@tyrell.hu>
Date: Sat, 22 Dec 2007 14:49:32 +0100
From: =?UTF-8?B?w4Frb3MgTWFyw7N5?= <darkeye@tyrell.hu>
Organization: Tyrell Corp.
User-Agent: Thunderbird 2.0.0.9 (X11/20071205)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: patch for using joysticks in 32 bit applications on 64 bit systems
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unfortunately 32 bit apps don't see the joysticks on a 64 bit system.
this prevents one playing X-Plane (http://www.x-plane.com/) or other
32-bit games with joysticks.

this is a known issue, and already raised several times:

http://readlist.com/lists/vger.kernel.org/linux-kernel/28/144411.html

http://www.brettcsmith.org/wiki/wiki.cgi?action=browse&diff=1&id=OzyComputer/Joystick

unfortunately this is still not fixed in the mainline kernel.

it would be nice to have this fixed, so that people can play these games
without having to patch their kernel.

the following patch solves the problem on 2.6.22:


diff -Naur linux-2.6.22-suspend2-r2/fs/compat_ioctl.c
linux-2.6.22-suspend2-r2-joystick/fs/compat_ioctl.c
--- linux-2.6.22-suspend2-r2/fs/compat_ioctl.c  2007-12-22
14:08:14.000000000
+0100
+++ linux-2.6.22-suspend2-r2-joystick/fs/compat_ioctl.c 2007-12-22
14:07:54.000000000 +0100
@@ -10,6 +10,8 @@
  * ioctls.
  */

+#include <linux/joystick.h>
+
 #include <linux/types.h>
 #include <linux/compat.h>
 #include <linux/kernel.h>
@@ -3259,6 +3261,12 @@
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
 COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)

+/* joystick */
+COMPATIBLE_IOCTL(JSIOCGVERSION)
+COMPATIBLE_IOCTL(JSIOCGAXES)
+COMPATIBLE_IOCTL(JSIOCGBUTTONS)
+COMPATIBLE_IOCTL(JSIOCGNAME(0x200)) /* for X-Plane 8.03 */
+
 /* now things that need handlers */
 HANDLE_IOCTL(MEMREADOOB32, mtd_rw_oob)
 HANDLE_IOCTL(MEMWRITEOOB32, mtd_rw_oob)

