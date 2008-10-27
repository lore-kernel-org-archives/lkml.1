Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYJ0Ms6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYJ0Ms6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYJ0Msp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:48:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:35969 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYJ0Mso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=K6Rt7JtffkpxQ3ZohwPnrQQwKAt9EUxYHr01Q4X5KFFJ3JYYSAYWUKUWvRzOmrn2EL
         wkN40rX9NMB5FofudymKbjXS5Hcu21HIGQ3KkFaNW6tPVyMkKFgh8BjpC7Ef+vDq2n/h
         BOLQ+HM7Wm5R5me39Wbr3rJmd2wgGJs8UQSXM=
Message-ID: <ea11fea30810270548y11453b8i10eb53caff1838e8@mail.gmail.com>
Date: Mon, 27 Oct 2008 18:18:42 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] : Fix unused variable compilation warnings in drivers/net/wan/syncppp.c
Cc: mkatiyar@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch fixes the unused compilation warnings in
drivers/net/wan/syncppp.c when CONFIG_INET is not defined.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 drivers/net/wan/syncppp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/syncppp.c b/drivers/net/wan/syncppp.c
index 327d585..11124f3 100644
--- a/drivers/net/wan/syncppp.c
+++ b/drivers/net/wan/syncppp.c
@@ -756,10 +756,10 @@ static void sppp_cisco_input (struct sppp *sp,
struct sk_buff *skb)
 	case CISCO_ADDR_REQ:
 		/* Stolen from net/ipv4/devinet.c -- SIOCGIFADDR ioctl */
 		{
-		struct in_device *in_dev;
-		struct in_ifaddr *ifa;
 		__be32 addr = 0, mask = htonl(~0U); /* FIXME: is the mask correct? */
 #ifdef CONFIG_INET
+		struct in_device *in_dev;
+		struct in_ifaddr *ifa;
 		rcu_read_lock();
 		if ((in_dev = __in_dev_get_rcu(dev)) != NULL)
 		{
-- 
1.5.4.3


Thanks -
Manish
