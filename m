Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXGID3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXGID3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbXGID3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:29:08 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:29921 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbXGID3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MGm5je2kEGkldB1AkVkA5Gt/sQx7gDx9Xp/ipgvW351IfyrbEd5EuxmhjbYqGXyfw3B0avp6zUHSBX6aGe4CM9RMJvCNxYENul/8QsmiPGGh8BGFpDvtPekzctxuIAgek4hXPbRoQETVqOZ+IWzjXYgYtEmjnVSoz5C9KAfTVKM=
Message-ID: <aaab98560707082029u52ffce5eia32cfb57a29db78f@mail.gmail.com>
Date: Mon, 9 Jul 2007 11:29:04 +0800
From: "Micah Gruber" <micah.gruber@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, jgarzik@pobox.com
Subject: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in free_shared_mem() in drivers/net/s2io.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential null dereference bug where we dereference
nic before a null check. This patch simply moves the dereferencing
after the null check.

Signed-off-by: Micah Gruber < micah.gruber@gmail.com>

--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -789,12 +789,14 @@
        struct mac_info *mac_control;
        struct config_param *config;
        int lst_size, lst_per_page;
-       struct net_device *dev = nic->dev;
+       struct net_device *dev;
        int page_num = 0;

        if (!nic)
                return;

+       dev = nic->dev;
+
        mac_control = &nic->mac_control;
        config = &nic->config;
