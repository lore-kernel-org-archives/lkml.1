Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbYJEQiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbYJEQiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbYJEQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:36:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35285 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761202AbYJEQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:07 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 04/19] ib700wdt: Fix off by one
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:36:07 +0100
Message-ID: <20081005163604.3799.54969.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can end up accessing one byte out. Found by Zvonimir Rakamaric

Signed-off-by: Alan Cox <alan@redhat.com>


Fixes bug #11399
---

 drivers/watchdog/ib700wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 05a2810..d48a704 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -150,7 +150,7 @@ static int ibwdt_set_heartbeat(int t)
 {
 	int i;
 
-	if ((t < 0) || (t > 30))
+	if ((t < 0) || (t >= 30))
 		return -EINVAL;
 
 	for (i = 0x0F; i > -1; i--)

