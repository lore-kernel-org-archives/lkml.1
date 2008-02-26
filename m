Return-Path: <linux-kernel-owner+w=401wt.eu-S1764712AbYBZWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764712AbYBZWNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYBZWMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:12:41 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59784 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbYBZWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:12:39 -0500
X-Sasl-enc: qnOa6tzX1wqSQP3VWDG13M0bihIcupxa0NCIjLdJl30t 1204063957
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: lenb@kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: ACPI: thinkpad-acpi: fix hotkey_get_tablet_mode
Date: Tue, 26 Feb 2008 19:12:35 -0300
Message-Id: <1204063955-5739-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <20080225200354.GE16513@khazad-dum.debian.net>
References: <20080225200354.GE16513@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used the wrong return convention on hotkey_get_tablet_mode(), breaking a
lot of stuff.  Bad Henrique!

Fix it to return the status in the parameter-by-reference, and IO status on
the function return value. Duh.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
---
 drivers/misc/thinkpad_acpi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index bb269d0..6cb7812 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -1078,7 +1078,8 @@ static int hotkey_get_tablet_mode(int *status)
 	if (!acpi_evalf(hkey_handle, &s, "MHKG", "d"))
 		return -EIO;
 
-	return ((s & TP_HOTKEY_TABLET_MASK) != 0);
+	*status = ((s & TP_HOTKEY_TABLET_MASK) != 0);
+	return 0;
 }
 
 /*
-- 
1.5.4.2

