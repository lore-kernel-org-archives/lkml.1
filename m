Return-Path: <linux-kernel-owner+w=401wt.eu-S936106AbXHNEmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106AbXHNEmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933719AbXHNEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:42:24 -0400
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92]:20796 "HELO
	n7.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933873AbXHNEmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:42:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 962719.8597.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5IQ77kkZbyiOcScXLv7LnMnse2Sn6k3I2pkiDey5FfTxGBEngmP73zGGU8irJoJOO8n/MlFv4kquzorEBi/FHEki37c6hn0NnOL89PSCaxHDqwu2NVwa8zVrIQotMLph2FoFAfYPbyUt4TfNgcGu0Hvq0OPWvvWF9TITVDg0ABY=;
X-YMail-OSG: 8SxOpjMVM1mSq4AoZYrLqOTuE6mtp1zsNOrb_7.5bHTb_ut1Iq8Ln2Nb.aOUig0g4tce63852SXXIUxJtmxvmyaYcry40H4jwqs-
Date: Mon, 13 Aug 2007 21:42:17 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 1/3] /drivers/net ioremap balancing/returncode check (resend)
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, postfail@hushmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <851437.53933.qm@web44909.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

resending patchset against 2.6.23-rc3 for /drivers/net ioremap balancing / return check,
previous patchset contained wordwrap errors:

  corrects:
  --sbus_ioremap return unchecked.
  --ioremap function unchecked
  --function failure cases did not clean up ioremap'd values.
  lne390.c  -- believe had incorrect/not ideal variable check on if for iounmap

this audit was only for files directly in drivers/net directory, not the full tree.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/net/es3210.c b/drivers/net/es3210.c
index 822e5bf..d7d6b90 100644
--- a/drivers/net/es3210.c
+++ b/drivers/net/es3210.c
@@ -307,6 +307,10 @@ out1:
 	free_irq(dev->irq, dev);
 out:
 	release_region(ioaddr + ES_SA_PROM, ES_IO_EXTENT);
+
+	if (ei_status.mem)
+		iounmap(ei_status.mem);
+	
 	return retval;
 }
 
diff --git a/drivers/net/lne390.c b/drivers/net/lne390.c
index 0a08d0c..f6d9fb6 100644
--- a/drivers/net/lne390.c
+++ b/drivers/net/lne390.c
@@ -290,7 +290,7 @@ static int __init lne390_probe1(struct net_device *dev, int ioaddr)
 		goto unmap;
 	return 0;
 unmap:
-	if (ei_status.reg0)
+	if (ei_status.mem)
 		iounmap(ei_status.mem);
 cleanup:
 	free_irq(dev->irq, dev);


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC

