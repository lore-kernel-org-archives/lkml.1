Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0BASZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:25:57 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:36412 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab0BASZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:25:55 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Alan Cox <alan@redhat.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 2/2] irda: add missing BKL in irnet_ppp ioctl
Date: Mon,  1 Feb 2010 16:21:35 -0200
Message-Id: <1265048496-8149-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265048496-8149-1-git-send-email-cascardo@holoscopio.com>
References: <1265048496-8149-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One ioctl has been forgotten when the BKL was push down into irnet_ppp
ioctl function.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 net/irda/irnet/irnet_ppp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 8d38fdd..67aee5c 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -695,9 +695,11 @@ dev_irnet_ioctl(
 
       /* Query PPP channel and unit number */
     case PPPIOCGCHAN:
+      lock_kernel();
       if(ap->ppp_open && !put_user(ppp_channel_index(&ap->chan),
 						(int __user *)argp))
 	err = 0;
+      unlock_kernel();
       break;
     case PPPIOCGUNIT:
       lock_kernel();
-- 
1.6.6.1

