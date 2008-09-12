Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYILRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYILRkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYILRjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:39:52 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41150 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753202AbYILRjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:39:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=czxYY6K4oV0ZUEOic1G1v3f9GTJ3c4FNGitygFkQt7dzxxUtkkLZDsZkR94Cx93E081EUvMf+5NTWL2AOa+9b/k6tlvK9GNSBOVhU7oHPmhm3Ke3u5auYd33z5Sm2D1Le5zxyB5DeaOsglvmuFS8Ir2Jv5uLYylElkSBmeNxLsk=  ;
X-YMail-OSG: ezAXGaYVM1nve1oplKwfzZjxA2ICXxuuGK.KWQVe50aFI4NYWIowjFp7_LH21Xsm3ZzNpmaFqriRXFsN8BLJz7h3IukiEZ6ixFwzg8G1Uvs37OU_p.FNCIa0cH5yZcCbQWgMQ81Rc5fxtU7AUM6l1yvv
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc6] Documentation/ABI: /sys/class/gpio
Date: Fri, 12 Sep 2008 09:51:22 -0700
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809120951.22570.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Provide summary ABI docs about the /sys/class/gpio files.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
For 2.6.27 ... let's make Greg happy.  :)

 Documentation/ABI/testing/sysfs-gpio |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/Documentation/ABI/testing/sysfs-gpio	2008-07-25 12:38:50.000000000 -0700
@@ -0,0 +1,26 @@
+What:		/sys/class/gpio/
+Date:		July 2008
+KernelVersion:	2.6.27
+Contact:	David Brownell <dbrownell@users.sourceforge.net>
+Description:
+
+  As a Kconfig option, individual GPIO signals may be accessed from
+  userspace.  GPIOs are only made available to userspace by an explicit
+  "export" operation.  If a given GPIO is not claimed for use by
+  kernel code, it may be exported by userspace (and unexported later).
+  Kernel code may export it for complete or partial access.
+
+  GPIOs are identified as they are inside the kernel, using integers in
+  the range 0..INT_MAX.  See Documentation/gpio.txt for more information.
+
+    /sys/class/gpio
+	/export ... asks the kernel to export a GPIO to userspace
+	/unexport ... to return a GPIO to the kernel
+	/gpioN ... for each exported GPIO #N
+	    /value ... always readable, writes fail for input GPIOs
+	    /direction ... r/w as: in, out (default low); write: high, low
+	/gpiochipN ... for each gpiochip; #N is its first GPIO
+	    /base ... (r/o) same as N
+	    /label ... (r/o) descriptive, not necessarily unique
+	    /ngpio ... (r/o) number of GPIOs; numbered N to N + (ngpio - 1)
+
