Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbYLUTtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbYLUTtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYLUTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:49:46 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35842 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYLUTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:49:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type:from;
        b=ZSRtCDDS8C3TG4mk9LRffjWgCAYh4EtFyZrjKHSbg2QKqM+Np36OJ0lQFkZrTE/G4s
         TtKW3hzwR6QwUeY58PbXJSWdO9+NPUWO/b6bCWF6804oAL/sb5sn8DeseK5gnIiCCitb
         y7qy9X7hin25URsicMVAnZDYnR88Lhdg4gkdo=
Date: Sun, 21 Dec 2008 14:49:19 -0500 (EST)
X-X-Sender: parag@parag-desktop
To: Jiri Kosina <jkosina@suse.cz>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
In-Reply-To: <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
Message-ID: <alpine.DEB.2.00.0812211441300.7101@parag-desktop>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>  <20081220221253.e09b1b1f.akpm@linux-foundation.org>  <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>  <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Parag Warudkar <parag.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The usbmouse and usbkbd modules are not supposed to be used with regular 
USB mice and keyboards. Make them depend on EMBEDDED to prevent them from 
being built and loaded on non-EMBEDDED configs.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 5d9aa95..4edb3be 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -45,7 +45,7 @@ config USB_HIDDEV
 	  If unsure, say Y.
 
 menu "USB HID Boot Protocol drivers"
-	depends on USB!=n && USB_HID!=y
+	depends on USB!=n && USB_HID!=y && EMBEDDED
 
 config USB_KBD
 	tristate "USB HIDBP Keyboard (simple Boot) support"
