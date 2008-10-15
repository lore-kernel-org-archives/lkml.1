Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbYJOA4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbYJOA4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYJOA42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:28 -0400
Received: from gw.goop.org ([64.81.55.164]:36855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYJOA41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] xen: don't reload cr3 on suspend
X-Mercurial-Node: ec2a7259b60569d0cf73a07b0b98dd06e01aba0e
Message-Id: <ec2a7259b60569d0cf73.1224031840@abulafia.goop.org>
In-Reply-To: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't necessary, and it makes the code needlessly non-portable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/manage.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -38,8 +38,6 @@
 	int err;
 
 	BUG_ON(!irqs_disabled());
-
-	load_cr3(swapper_pg_dir);
 
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {


