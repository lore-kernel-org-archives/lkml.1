Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXGaSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXGaSRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763416AbXGaSRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:17:03 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3037 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760809AbXGaSRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:17:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 39] net/ipv4/ip_options.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:16:59 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, davem@davemloft.net
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312016.59970.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/ip_options.c | 15425 -> 15368 (-57 bytes)
 net/ipv4/ip_options.o | 133668 -> 133588 (-80 bytes)

 net/ipv4/ip_options.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/net/ipv4/ip_options.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/net/ipv4/ip_options.c	2007-07-31 15:17:22.000000000 +0200
@@ -513,11 +513,8 @@ void ip_options_undo(struct ip_options *

 static struct ip_options *ip_options_get_alloc(const int optlen)
 {
-	struct ip_options *opt = kmalloc(sizeof(*opt) + ((optlen + 3) & ~3),
-					 GFP_KERNEL);
-	if (opt)
-		memset(opt, 0, sizeof(*opt));
-	return opt;
+	return kzalloc(sizeof(struct ip_options) + ((optlen + 3) & ~3),
+		       GFP_KERNEL);
 }

 static int ip_options_get_finish(struct ip_options **optp,
