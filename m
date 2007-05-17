Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXEQL0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXEQL0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbXEQL0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:26:38 -0400
Received: from smtp105.plus.mail.re2.yahoo.com ([206.190.53.30]:41900 "HELO
	smtp105.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756625AbXEQL0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:26:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=NLa39heHayPiM2f+z00/MnKO1+d9O6pxWG9gFEYrN32HjOmW3tb2GB2Jy+Vt7f/XBa6yJ/t2upKlZFRUV3RiMGBftgI181AdfJMDF3tfiG7JpzmSqrp32epYi8j8v3Cy0Fi6r8H5692l8T6rh0ryZzP4HcauHpEti1jimIQRgew=  ;
X-YMail-OSG: SopHLgoVM1kykU2LEgAex9wShgUu4rVqwCLsJoLTCHcfP4Gz25.MuzKTVFrmSDW3HAJHwTPdKg--
Date: Thu, 17 May 2007 13:25:54 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ide.c: microscopic size and readability optimization
Message-ID: <20070517112554.GA32183@zmei.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----
From: bbpetkov@yahoo.de

A very small size (object file 432 bytes smaller) and readability optimization of ide.c

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
Index: 22-rc1/drivers/ide/ide.c
===================================================================
--- 22-rc1/drivers/ide/ide.c.orig
+++ 22-rc1/drivers/ide/ide.c
@@ -568,10 +568,8 @@ void ide_unregister(unsigned int index)
 	ide_hwgroup_t *hwgroup;
 	int irq_count = 0, unit;

-	BUG_ON(index >= MAX_HWIFS);
+	BUG_ON(index >= MAX_HWIFS || in_interrupt() || irqs_disabled());

-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());
 	down(&ide_cfg_sem);
 	spin_lock_irq(&ide_lock);
 	hwif = &ide_hwifs[index];
