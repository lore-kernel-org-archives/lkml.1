Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbZLGAYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbZLGAYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbZLGAYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:24:23 -0500
Received: from kroah.org ([198.145.64.141]:34556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494AbZLGANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:53 2009
Message-Id: <20091207000653.339579495@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [073/119] acenic: Pass up error code from ace_load_firmware()
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=acenic-pass-up-error-code-from-ace_load_firmware.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 6c60e0c30c80fcd53e61701b7865a85283f8a341 ]

If ace_load_firmware() fails, ace_init() cleans up but still returns
0, leading to an oops as seen in <http://bugs.debian.org/521383>.
It should pass the error code up.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/acenic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -1209,7 +1209,8 @@ static int __devinit ace_init(struct net
 	memset(ap->info, 0, sizeof(struct ace_info));
 	memset(ap->skb, 0, sizeof(struct ace_skb));
 
-	if (ace_load_firmware(dev))
+	ecode = ace_load_firmware(dev);
+	if (ecode)
 		goto init_error;
 
 	ap->fw_running = 0;


