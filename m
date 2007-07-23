Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbXGWG6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbXGWG6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbXGWG5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:14 -0400
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:47368 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759939AbXGWG4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=L/41oW9WpiLfIKGk9dc7YDBbBvQQV/m7bmAMb1oKLfzqj45oQ1JX5NftRzftQImtpO/egLbprjXXx0rx5PqUqZIvY2VABFoR1mqJWyFlUHpagTDSvLNCoLpo7ur30MWLh7wsnnGx2eMnKWLzRSZMDycNahRMwMu2E7Sz9uEkAf0=  ;
X-YMail-OSG: iIYXo2IVM1mNUWU3YAUfhiHoamcuGbikpyjtmsT.HfwukBSfU5f.2URn.c7eFFXF4aIAvI63pA--
Date: Mon, 23 Jul 2007 08:56:04 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] usb/atm: fix Kconfig garbage
Message-ID: <20070723065604.GA8525@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I don't know whether this is the proper Kconfig-way to fix this but it works ok here.

----
When entered, the menu point "USB DSL modem support" in menuconfig, path [Device Drivers->USB
Support] shows no entries but "^@" instead. The following fixes it.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
--- linux-2.6.23-rc1/drivers/usb/atm/Kconfig.orig	2007-07-23 08:27:29.000000000 +0200
+++ linux-2.6.23-rc1/drivers/usb/atm/Kconfig	2007-07-23 08:50:55.000000000 +0200
@@ -7,7 +7,8 @@ menu "USB DSL modem support"
 
 config USB_ATM
 	tristate "USB DSL modem support"
-	depends on USB && ATM
+	depends on USB
+	select ATM
 	select CRC32
 	default n
 	help
-- 
Regards/Gruﬂ,
    Boris.
