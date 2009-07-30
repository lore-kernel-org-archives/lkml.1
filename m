Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZG3SiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZG3SiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZG3SiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:38:25 -0400
Received: from mx05.kabsi.at ([195.202.128.131]:34356 "EHLO mx05.kabsi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZG3SiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:38:24 -0400
Date: Thu, 30 Jul 2009 20:37:36 +0200
From: Jakob Gruber <jakob.gruber@kabelnet.at>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing device IDs in rt2870
Message-Id: <20090730203736.f1efbbfe.jakob.gruber@kabelnet.at>
In-Reply-To: <20090729161643.GA6313@suse.de>
References: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
	<20090728211216.GA12363@suse.de>
	<20090729171107.155719b5.jakob.gruber@kabelnet.at>
	<20090729161643.GA6313@suse.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__30_Jul_2009_20_37_36_+0200_LsYdg0PNA_CqXmec"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__30_Jul_2009_20_37_36_+0200_LsYdg0PNA_CqXmec
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2009 09:16:43 -0700
Greg KH <gregkh@suse.de> wrote:

<snip>
> > 
> > I haven't tested rt2870 in 2.6.30 thoroughly because of this bug
> > (http://bugzilla.kernel.org/show_bug.cgi?id=13638), which forces me to
> > use the driver from the Ralink website instead of the kernel module.
> > However, I can confirm that - until running into the bug - the Belkin
> > card also works in 2.6.30. 
> 
> Ah, that sucks.  I should revert that patch, if you do that, does the
> device work properly for you?

'git revert' didn't work out of the box, and I don't think I'm skilled enough to revert it manually :)
However, I posted some more information at http://bugzilla.kernel.org/show_bug.cgi?id=13638#c9 , including everything.log during the crash.

> 
> > A patch for adding the Belkin device ID is attached. I removed the
> > other 2 IDs from http://bugzilla.kernel.org/show_bug.cgi?id=13459
> > since I do not own these devices and cannot verify them. The ID is
> > only added to the "#ifndef RT30xx" block, same as the patch applied to
> > the Archlinux kernel.
> 
> I'll take the other two ids, now that it makes more sense.
> 
> Care to respin with the 2 new ids, and add a "Signed-off-by:" to the
> patch so I can properly apply it?

Done, patch is attached. 

Thanks again.

-- 
Jakob Gruber <jakob.gruber@kabelnet.at>


--Multipart=_Thu__30_Jul_2009_20_37_36_+0200_LsYdg0PNA_CqXmec
Content-Type: text/plain;
 name="0001-Staging-rt2870-Add-USB-ID-for-Linksys-Planex-Communi.patch"
Content-Disposition: attachment;
 filename="0001-Staging-rt2870-Add-USB-ID-for-Linksys-Planex-Communi.patch"
Content-Transfer-Encoding: 7bit

>From f3f763c05dac00b97aaa8d16dc61a509b098fadd Mon Sep 17 00:00:00 2001
From: Jakob Gruber <jakob.gruber@kabelnet.at>
Date: Thu, 30 Jul 2009 20:25:47 +0200
Subject: [PATCH] Staging: rt2870: Add USB ID for Linksys, Planex Communications, Belkin

Linksys WUSB100, Belkin F5D8053 N, Planex Communications unknown model.

Signed-off-by: Jakob Gruber <jakob.gruber@kabelnet.at>
---
 drivers/staging/rt2870/rt2870.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2870/rt2870.h b/drivers/staging/rt2870/rt2870.h
index 29e3b53..10e1640 100644
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -79,6 +79,7 @@
 {	\
 	{USB_DEVICE(0x148F,0x2770)}, /* Ralink */		\
 	{USB_DEVICE(0x1737,0x0071)}, /* Linksys WUSB600N */	\
+	{USB_DEVICE(0x1737,0x0070)}, /* Linksys */	\
 	{USB_DEVICE(0x148F,0x2870)}, /* Ralink */		\
 	{USB_DEVICE(0x148F,0x3070)}, /* Ralink */		\
 	{USB_DEVICE(0x0B05,0x1731)}, /* Asus */			\
@@ -93,12 +94,14 @@
 	{USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */		\
 	{USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */		\
 	{USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */		\
+	{USB_DEVICE(0x2019,0xED14)}, /* Planex Communications, Inc. */		\
 	{USB_DEVICE(0x2019,0xAB25)}, /* Planex Communications, Inc. RT3070 */		\
 	{USB_DEVICE(0x07D1,0x3C09)}, /* D-Link */		\
 	{USB_DEVICE(0x07D1,0x3C11)}, /* D-Link */		\
 	{USB_DEVICE(0x14B2,0x3C07)}, /* AL */			\
 	{USB_DEVICE(0x14B2,0x3C12)}, /* AL */           \
 	{USB_DEVICE(0x050D,0x8053)}, /* Belkin */		\
+	{USB_DEVICE(0x050D,0x815C)}, /* Belkin */		\
 	{USB_DEVICE(0x14B2,0x3C23)}, /* Airlink */		\
 	{USB_DEVICE(0x14B2,0x3C27)}, /* Airlink */		\
 	{USB_DEVICE(0x07AA,0x002F)}, /* Corega */		\
-- 
1.6.4


--Multipart=_Thu__30_Jul_2009_20_37_36_+0200_LsYdg0PNA_CqXmec--
