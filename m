Return-Path: <linux-kernel-owner+w=401wt.eu-S936652AbZFPF6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936652AbZFPF6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935751AbZFPFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:22 -0400
Received: from kroah.org ([198.145.64.141]:48385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935663AbZFPFvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/64] Driver Core: input: add nodename for input drivers
Date: Mon, 15 Jun 2009 22:46:20 -0700
Message-Id: <1245131213-24168-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the input core to report the proper device name to
userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/input.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 5d445f4..7c237e6 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1265,8 +1265,14 @@ static struct device_type input_dev_type = {
 	.uevent		= input_dev_uevent,
 };
 
+static char *input_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "input/%s", dev_name(dev));
+}
+
 struct class input_class = {
 	.name		= "input",
+	.nodename	= input_nodename,
 };
 EXPORT_SYMBOL_GPL(input_class);
 
-- 
1.6.3.2

