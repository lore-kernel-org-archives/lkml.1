Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYFMEkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYFMEkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYFMEjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:39:42 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:38968 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751442AbYFMEjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:39:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=0pSn4rzjaejqc03RdWv5wSjhA2qs+PUEgQgXtKu/naDhyJJyfRzxilzHpn26u7O/wyXUC/tk3Ko4OcOZqGs73H9ZVXxfJXYe0lYKFUGHPXel8+SrDYuF1gC53vOMtMlaH+v7H8NLorPbER5funp/rpwPWniqsKy5tWt9Sqz6m68=  ;
X-YMail-OSG: Kk8hn3YVM1kJVd_E2OyKlRw9SH7mPVY7YGGvN8yRJ5mIQRbXOOp7RYV7A2kO_u0TWobaVLMTuL8xkmnjjHUwNy56Hj8F1y7NOBJRJ9b9aA--
X-Yahoo-Newman-Property: ymail-3
To: netdev@vger.kernel.org
Subject: [RESEND #4/patch 2.6.26-rc6] net/enc28j60: section fix
Cc: Claudio Lanconelli <lanconelli.claudio@eptar.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Thu, 12 Jun 2008 21:36:24 -0700
MIME-Version: 1.0
Message-Id: <200806122136.24921.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor bugfixes to the enc28j60 driver ... wrong section marking,
indentation, and bogus use of spi_bus_type.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Claudio Lanconelli <lanconelli.claudio@eptar.com>
---
Previously sent:  18-April, 19-February, 6-February.

 drivers/net/enc28j60.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- g26.orig/drivers/net/enc28j60.c	2008-02-22 19:48:13.000000000 -0800
+++ g26/drivers/net/enc28j60.c	2008-02-22 19:48:14.000000000 -0800
@@ -1556,7 +1556,7 @@ error_alloc:
 	return ret;
 }
 
-static int enc28j60_remove(struct spi_device *spi)
+static int __devexit enc28j60_remove(struct spi_device *spi)
 {
 	struct enc28j60_net *priv = dev_get_drvdata(&spi->dev);
 
@@ -1573,9 +1573,8 @@ static int enc28j60_remove(struct spi_de
 static struct spi_driver enc28j60_driver = {
 	.driver = {
 		   .name = DRV_NAME,
-		   .bus = &spi_bus_type,
 		   .owner = THIS_MODULE,
-		   },
+	 },
 	.probe = enc28j60_probe,
 	.remove = __devexit_p(enc28j60_remove),
 };
