Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZCRQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZCRQ61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbZCRQ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:58:18 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35223 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZCRQ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:58:17 -0400
Message-ID: <49C128A0.7030805@oracle.com>
Date: Wed, 18 Mar 2009 10:00:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: [PATCH] staging/line6: fix build error, select SND_RAWMIDI
References: <20090318173830.7ea03dfb.sfr@canb.auug.org.au>
In-Reply-To: <20090318173830.7ea03dfb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49C1281C.0026:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

line6 needs to select SND_RAWMIDI, like many other drivers do.

ERROR: "snd_rawmidi_set_ops" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_rawmidi_new" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_rawmidi_transmit_peek" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_rawmidi_transmit_ack" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_rawmidi_receive" [drivers/staging/line6/line6usb.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/line6/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090318.orig/drivers/staging/line6/Kconfig
+++ linux-next-20090318/drivers/staging/line6/Kconfig
@@ -1,6 +1,7 @@
 config LINE6_USB
 	tristate "Line6 USB support"
 	depends on USB && SND
+	select SND_RAWMIDI
 	help
 	  This is a driver for the guitar amp, cab, and effects modeller
 	  PODxt Pro by Line6 (and similar devices), supporting the
