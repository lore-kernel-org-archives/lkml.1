Return-Path: <linux-kernel-owner+w=401wt.eu-S932205Ab0AETxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab0AETxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170Ab0AETxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:53:09 -0500
Received: from kroah.org ([198.145.64.141]:46039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0AETw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:52:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 11:49:15 2010
Message-Id: <20100105194915.239350321@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 11:47:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [08/10] rt2x00: Disable powersaving for rt61pci and rt2800pci.
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 93b6bd26b74efe46b4579592560f9f1cb7b61994 upstream.

We've had many reports of rt61pci failures with powersaving enabled.
Therefore, as a stop-gap measure, disable powersaving of the rt61pci
until we have found a proper solution.
Also disable powersaving on rt2800pci as it most probably will show
the same problem.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2281,6 +2281,11 @@ static void rt61pci_probe_hw_mode(struct
 	unsigned int i;
 
 	/*
+	 * Disable powersaving as default.
+	 */
+	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
+	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =


