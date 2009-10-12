Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZJLCpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZJLCpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZJLCpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:45:11 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:48136 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZJLCpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=LdM7muHPBBkdWlXMU/GlKjEAyeruCcljQu1/R5YWS5MvV+4/5kKNjLoFE93yTN7xQf
         ObD2XEqbkBgsIxvIaHbJvGcjGgYAjLmdX7Gm6CZ4zKtP+j47yCySZ7XpzI8czivtqRIv
         LnaBpE5L1zCLqbyFj9zVL/po8cSyraNfjAVOQ=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 08:44:33 +0600
Message-ID: <b9df5fa10910111944s274207aica39c0e646c10f7a@mail.gmail.com>
Subject: [PATCH -mm] connector: Passing required parameter for function 
	cn_add_callback.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, zbr@ioremap.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 We need to pass struct netlink_skb_parms as parameter for
cn_proc_mcast_ctl, which
is a callback function supposed to take two parameter. Fixes the
following warning and
a kernel-doc notation of the function.

  CC      drivers/connector/cn_proc.o
drivers/connector/cn_proc.c: In function `cn_proc_init':
drivers/connector/cn_proc.c:263: warning: passing arg 3 of
`cn_add_callback' from incompatible pointer type

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/connector/cn_proc.c	2009-10-09 17:38:22.000000000 +0600
+++ rakib/drivers/connector/cn_proc.c	2009-10-12 09:45:33.000000000 +0600
@@ -225,9 +225,10 @@ static void cn_proc_ack(int err, int rcv

 /**
  * cn_proc_mcast_ctl
- * @data: message sent from userspace via the connector
+ * @msg: message sent from userspace via the connector
+ * @nsp: remains unused but we need it to keep it
  */
-static void cn_proc_mcast_ctl(struct cn_msg *msg)
+static void cn_proc_mcast_ctl(struct cn_msg *msg, struct
netlink_skb_parms *nsp)
 {
 	enum proc_cn_mcast_op *mc_op = NULL;
 	int err = 0;
