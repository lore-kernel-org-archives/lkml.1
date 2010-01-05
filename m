Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359Ab0AETWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0AETWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363Ab0AETWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:22:10 -0500
Received: from kroah.org ([198.145.64.141]:55822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0AETWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:22:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Gertjan van Wingerde <gwingerde@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 099/101] rt2x00: Disable powersaving for rt61pci and rt2800pci.
Date: Tue,  5 Jan 2010 11:21:27 -0800
Message-Id: <1262719290-310-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262719290-310-1-git-send-email-gregkh@suse.de>
References: <20100105192014.GA23628@kroah.com>
 <1262719290-310-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b20e3ea..1894e7e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2538,6 +2538,11 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
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
-- 
1.6.6

