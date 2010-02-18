Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0BRW2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:28:32 -0500
Received: from mail.perches.com ([173.55.12.10]:1093 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0BRW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:28:31 -0500
Subject: Re: printk_ratelimited() not compiling
From: Joe Perches <joe@perches.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1266531013.3201.86.camel@localhost.localdomain>
References: <1266531013.3201.86.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 14:28:30 -0800
Message-ID: <1266532110.8446.284.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 14:10 -0800, john stultz wrote:
> I thought printk_ratelimited would be perfect for an issue I'm
> having, but when I tried using it, replacing a printk I had, I got the
> following:

[]

> fs/namei.c:1075: error: variable ‘_rs’ has initializer but incomplete type

[]

> Am I missing something obvious, or did something get broken after this went in?

Dunno.
Maybe you typed printk_ratelimit not printk_ratelimited?
Can you send the code you're using?

I just tried it in drivers/net/tg3.c and it compiled fine.

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 7f82b02..cf9b0d8 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1092,7 +1092,7 @@ static int tg3_mdio_init(struct tg3 *tp)
 
 	i = mdiobus_register(tp->mdio_bus);
 	if (i) {
-		printk(KERN_WARNING "%s: mdiobus_reg failed (0x%x)\n",
+		printk_ratelimited(KERN_WARNING "%s: mdiobus_reg failed (0x%x)\n
 			tp->dev->name, i);
 		mdiobus_free(tp->mdio_bus);
 		return i;


