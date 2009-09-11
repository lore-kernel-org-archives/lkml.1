Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZIKAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZIKAaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZIKAay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:30:54 -0400
Received: from kroah.org ([198.145.64.141]:38103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZIKA3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:11 2009
Message-Id: <20090911002411.498265593@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 16/22] sound: oxygen: handle cards with missing EEPROM
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=sound-oxygen-handle-cards-with-missing-eeprom.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 92653453c3015c083b9fe0ad48261c6b2267d482 upstream.

The card model detection code introduced in 2.6.30 that tries to work
around partially broken EEPROM contents by reading the EEPROM directly
does not handle cards where the EEPROM has been omitted.  In this case,
we have to use the default ID to allow the driver to load.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen_lib.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -260,6 +260,9 @@ oxygen_search_pci_id(struct oxygen *chip
 	 * chip didn't if the first EEPROM word was overwritten.
 	 */
 	subdevice = oxygen_read_eeprom(chip, 2);
+	/* use default ID if EEPROM is missing */
+	if (subdevice == 0xffff)
+		subdevice = 0x8788;
 	/*
 	 * We use only the subsystem device ID for searching because it is
 	 * unique even without the subsystem vendor ID, which may have been


