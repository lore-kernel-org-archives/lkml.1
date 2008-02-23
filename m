Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbYBWNTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbYBWNTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbYBWNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:19:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12965 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbYBWNTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:19:37 -0500
X-SBRS: 2.8
X-MesageID: 43201687
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,394,1199682000"; 
   d="scan'208";a="43201687"
Date: Sat, 23 Feb 2008 14:17:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Braille screen reader documentation
Message-ID: <20080223131747.GE4244@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation> <20080222002822.GB32480@implementation> <20080223000410.674ce674.akpm@linux-foundation.org> <20080223131028.GC4244@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223131028.GC4244@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the console=brl option and the usage of the braille screen
reader.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux-2.6.24.1-orig/Documentation/kernel-parameters.txt	2008-01-25 09:31:45.000000000 +0100
+++ linux-2.6.24.1-perso/Documentation/kernel-parameters.txt	2008-02-23 13:21:27.000000000 +0100
@@ -463,6 +463,11 @@
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
+                If the device connected to the port is not a TTY but a braille
+                device, prepend "brl," before the device type, for instance
+			console=brl,ttyS0
+		For now, only VisioBraille is supported.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
--- linux-2.6.24.1-orig/Documentation/braille-console.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24.1-perso/Documentation/braille-console.txt	2008-02-23 13:20:31.000000000 +0100
@@ -0,0 +1,34 @@
+                       Linux Braille Console
+
+To get early boot messages on a braille device (before userspace screen
+readers can start), you first need to compile the support for the usual serial
+console (see serial-console.txt), and for braille device (in Device Drivers -
+Accessibility).
+
+Then you need to specify a console=brl, option on the kernel command line, the
+format is:
+
+	console=brl,serial_options...
+
+where serial_options... are the same as described in serial-console.txt
+
+So for instance you can use console=brl,ttyS0 if the braille device is connected
+to the first serial port, and console=brl,ttyS0,115200 to override the baud rate
+to 115200, etc.
+
+By default, the braille device will just show the last kernel message (console
+mode).  To review previous messages, press the Insert key to switch to the VT
+review mode.  In review mode, the arrow keys permit to browse in the VT content,
+page up/down keys go at the top/bottom of the screen, and the home key goes back
+to the cursor, hence providing very basic screen reviewing facility.
+
+Sound feedback can be obtained by adding the braille_console.sound=1 kernel
+parameter.
+
+For simplicity, only one braille console can be enabled, other uses of
+console=brl,... will be discarded.  Also note that it does not interfere with
+the console selection mecanism described in serial-console.txt
+
+For now, only the VisioBraille device is supported.
+
+Samuel Thibault <samuel.thibault@ens-lyon.org>
