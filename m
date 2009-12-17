Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbZLQBdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbZLQBdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935970AbZLQBce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:32:34 -0500
Received: from kroah.org ([198.145.64.141]:48069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763663AbZLQBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.681672604@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [59/90] sunsab: Do not set sunsab_reg.cons right before registering minors.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 4e68e188411ea98e40309700cf0c89ad4469ac1d ]

Other Sun serial drivers do not do this, and if we keep it this way
it ends up registering all serial devices as consoles rather than
just the one which we explicitly register via sunserial_console_match()
which uses add_preferred_console().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/sunsab.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -1116,7 +1116,6 @@ static int __init sunsab_init(void)
 		if (!sunsab_ports)
 			return -ENOMEM;
 
-		sunsab_reg.cons = SUNSAB_CONSOLE();
 		err = sunserial_register_minors(&sunsab_reg, num_channels);
 		if (err) {
 			kfree(sunsab_ports);


