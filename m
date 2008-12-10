Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYLJQPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYLJQPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYLJQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:13:45 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:58176 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYLJQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:44 -0500
Message-ID: <493feab4.0aaa660a.7938.3213@mx.google.com>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Wed, 10 Dec 2008 16:13:44 +0100
Subject: [PATCH 4/9] mISDN: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make an exported symbol non static

Fix this warning:

  drivers/isdn/hardware/mISDN/hfcmulti.c:176:1: warning: symbol 'plx_lock' shadows an earlier one
  drivers/isdn/hardware/mISDN/hfcmulti.c:175:19: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

Note that patch introduces this new warning:

  drivers/isdn/hardware/mISDN/hfcmulti.c:175:12: warning: symbol 'plx_lock' was not declared. Should it be static?

Should 'plx_lock' be declared in a header file?  Or is it really
neccessart to export it?


 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 599d832..b4595f7 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -172,7 +172,7 @@ static int interrupt_registered;
 
 static struct hfc_multi *syncmaster;
 static int plxsd_master; /* if we have a master card (yet) */
-static spinlock_t plx_lock; /* may not acquire other lock inside */
+spinlock_t plx_lock; /* may not acquire other lock inside */
 EXPORT_SYMBOL(plx_lock);
 
 #define	TYP_E1		1
-- 
1.5.6.3

