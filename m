Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbZEFUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbZEFUjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbZEFUit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:38:49 -0400
Received: from kroah.org ([198.145.64.141]:33821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761037AbZEFUis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:38:48 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:28 2009
Message-Id: <20090506203128.303389365@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 03/18] USB: Unusual Device support for Gold MP3 Player Energy
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=usb-unusual-device-support-for-gold-mp3-player-energy.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Short <zulcss@ubuntu.com>

upstream commit: 46c6e93faa85d1362e1d127dc28cf9d0b304a6f1

Reported by Alessio Treglia on
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/125250

User was getting the following errors in dmesg:

[ 2158.139386] sd 5:0:0:1: ioctl_internal_command return code = 8000002
[ 2158.139390] : Current: sense key: No Sense
[ 2158.139393] Additional sense: No additional sense information

Adds unusual device support.

modified:   drivers/usb/storage/unusual_devs.h

Signed-off-by: Chuck Short <zulcss@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2147,6 +2147,12 @@ UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_CAPACITY_HEURISTICS),
 
+/* Reported by Alessio Treglia <quadrispro@ubuntu.com> */
+UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
+		"TGE",
+		"Digital MP3 Audio Player",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
+
 /* Control/Bulk transport for all SubClass values */
 USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
 USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),


