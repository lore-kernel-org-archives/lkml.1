Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbXHPWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbXHPWLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbXHPWLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:11:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbXHPWLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=D2Ke8jA6mbUesGHn8/TuvRSwj2kga4kJKzwz+x6pcaqPJHaME5k/ezrPqnn1G+DbUI5Ejb6vy147NhsU98OSg81ApwW3DpdEMHgmG62aqAlDScsYOs0pHn7U9vBqDiZbdC2/P5DwLiHbSNFST0aQXGmCOmp/GcFUIZMkttYEIso=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Moxa: Fix tiny compiler warning when building withoug CONFIG_PCI
Date: Fri, 17 Aug 2007 00:08:58 +0200
User-Agent: KMail/1.9.7
Cc: support@moxa.com.tw, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170008.58649.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this tiny compiler warning in Moxa driver : 
  drivers/char/mxser.c:386: warning: 'mxser_get_PCI_conf' declared 'static' but never defined
when building without CONFIG_PCI.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/char/mxser.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 2aee3fe..83b15b5 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -383,7 +383,9 @@ static int mxser_init(void);
 
 /* static void   mxser_poll(unsigned long); */
 static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
+#ifdef CONFIG_PCI
 static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
+#endif
 static void mxser_do_softint(struct work_struct *);
 static int mxser_open(struct tty_struct *, struct file *);
 static void mxser_close(struct tty_struct *, struct file *);



