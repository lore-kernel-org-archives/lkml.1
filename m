Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYJ3Tqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYJ3Tqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYJ3TqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:46:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:56937 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYJ3TqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:46:24 -0400
Subject: Re: hid: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <490A0A35.9060606@gmail.com>
References: <1225385705.21973.20.camel@nga.site>
	 <490A0A35.9060606@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 20:35:16 +0100
Message-Id: <1225395316.21973.47.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 20:25 +0100, Jiri Slaby wrote:
> Kay Sievers napsal(a):
> > switch over to the new api, which will remove the 20 bytes array
> > and does no longer have a size limitation.
> 
> Cool!

> Could you left the comment above to remind us about removing this ugly hack
> later when the new non-limited api will be used?

Sure!

Thanks,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: hid: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Jiri Kosina <jkosina@suse.cz>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1903e75..27f1e16 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1613,9 +1613,10 @@ int hid_add_device(struct hid_device *hdev)
 	if (hid_ignore(hdev))
 		return -ENODEV;
 
-	/* XXX hack, any other cleaner solution < 20 bus_id bytes? */
-	sprintf(hdev->dev.bus_id, "%04X:%04X:%04X.%04X", hdev->bus,
-			hdev->vendor, hdev->product, atomic_inc_return(&id));
+	/* XXX hack, any other cleaner solution after the driver core
+	 * is converted to allow more than 20 bytes as the device name? */
+	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
+		     hdev->vendor, hdev->product, atomic_inc_return(&id));
 
 	ret = device_add(&hdev->dev);
 	if (!ret)


