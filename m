Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZLGAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZLGAZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZLGAZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:25:46 -0500
Received: from kroah.org ([198.145.64.141]:34483 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524AbZLGANT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:51 2009
Message-Id: <20091207000651.220378113@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [062/119] V4L/DVB (13321): radio-gemtek-pci: fix double mutex_lock
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13321-radio-gemtek-pci-fix-double-mutex_lock.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hans Verkuil <hverkuil@xs4all.nl>

commit 3addbb8075c00e2a2408c192bd1002dead26b2aa upstream.

Double mutexlock found by the Linux Driver Verification project and
reported by Alexander Strakh.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/radio-gemtek-pci.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/radio/radio-gemtek-pci.c
+++ b/drivers/media/radio/radio-gemtek-pci.c
@@ -181,12 +181,10 @@ static void gemtek_pci_mute(struct gemte
 
 static void gemtek_pci_unmute(struct gemtek_pci *card)
 {
-	mutex_lock(&card->lock);
 	if (card->mute) {
 		gemtek_pci_setfrequency(card, card->current_frequency);
 		card->mute = false;
 	}
-	mutex_unlock(&card->lock);
 }
 
 static int gemtek_pci_getsignal(struct gemtek_pci *card)


