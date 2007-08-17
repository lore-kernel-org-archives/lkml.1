Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbXHQVZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbXHQVZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXHQVZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:25:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29717 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbXHQVZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=D70oQI4aSWgg4ToChdZWfdQ7Q0TqO6KQsmZgxxMg+pb6pnCIQR/qQPRiuIk2UYhntHJ/WpKYlCwwAVuIp/wK2clPh9DC15TUqjhmulIJHg7N3D0ZtQ6H4GFCnMRikeA7jfotG2D9mkg+FDeLsT+Vcwg3D1JnFwtSJt9kWxddkDs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Subject: [PATCH] IRDA: Avoid a label defined but not used warning in irda_init()
Date: Fri, 17 Aug 2007 23:22:33 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dag Brattli <dagb@cs.uit.no>, Jean Tourrilhes <jt@hpl.hp.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708172322.34105.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Easily avoidable compiler warnings bug me.


Building irmod without CONFIG_SYSCTL currently results in : 
 net/irda/irmod.c:132: warning: label 'out_err_2' defined but not used

But that can easily be avoided by simply moving the label inside 
the existing "#ifdef CONFIG_SYSCTL" one line above it.

This patch moves the label and buys us one less warning with no 
ill effects.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 net/irda/irmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/irda/irmod.c b/net/irda/irmod.c
index 1900937..8ba703d 100644
--- a/net/irda/irmod.c
+++ b/net/irda/irmod.c
@@ -128,8 +128,8 @@ static int __init irda_init(void)
  out_err_3:
 #ifdef CONFIG_SYSCTL
 	irda_sysctl_unregister();
-#endif
  out_err_2:
+#endif
 #ifdef CONFIG_PROC_FS
 	irda_proc_unregister();
 #endif



