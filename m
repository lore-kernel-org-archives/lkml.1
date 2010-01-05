Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011Ab0AEAwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0AEAwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974Ab0AEAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:52:29 -0500
Received: from kroah.org ([198.145.64.141]:34165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0AEAe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/97] Bluetooth: Prevent ill-timed autosuspend in USB driver
Date: Mon,  4 Jan 2010 16:32:37 -0800
Message-Id: <1262651630-7354-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>

commit 652fd781a52ad6e24b908cd8b83d12699754f253 upstream.

The device must be marked busy as it receives data.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Tested-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/bluetooth/btusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 44bc8bb..1be7631 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -307,6 +307,7 @@ static void btusb_bulk_complete(struct urb *urb)
 		return;
 
 	usb_anchor_urb(urb, &data->bulk_anchor);
+	usb_mark_last_busy(data->udev);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-- 
1.6.6

