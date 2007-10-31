Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbXJaRMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbXJaRMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXJaRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:12:30 -0400
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:21547 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756592AbXJaRM2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:12:28 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 13:12:28 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0KCc1XPegyQB6ZzNNo4p3MbNn/pWbIhUR3guIJzJKp5ZNnDp7h8By5FzXlazYkWSulpVG93N/irTfGPsV6pWKG5mA6CdKm1XaqHD3Y49aqV12zChFRGj8uoh4vG95/qLYepCmFBpGac2ilN7/ueHRW9kUxmLhwlmzyIvUOAWcyE=;
X-YMail-OSG: LuQgM6UVM1nzkXWBlat60CoPr1frGs36WHwQYfUsQfYlwxfMUzzC3WmKtOJ1bbyfW6k.y7q4OTas672L.3Vwu8OBxvScTsSonaI66KzfGRB6Ny8RrFk-
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.134.12
Date: Wed, 31 Oct 2007 10:05:46 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] telephony: phonedev panics if unregistering device not registered [Bug 9266]
To: linux-kernel@vger.kernel.org
Cc: bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <224028.52554.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Remove panic from phonedev.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
---

--- a/drivers/telephony/phonedev.c	2007-10-31 17:52:55.784817000 +0200
+++ linux-2.6.24/drivers/telephony/phonedev.c	2007-10-31 17:55:48.144879000 +0200
@@ -120,9 +120,8 @@ int phone_register_device(struct phone_d
 void phone_unregister_device(struct phone_device *pfd)
 {
 	mutex_lock(&phone_lock);
-	if (phone_device[pfd->minor] != pfd)
-		panic("phone: bad unregister");
-	phone_device[pfd->minor] = NULL;
+	if (likely(phone_device[pfd->minor] == pfd))
+		phone_device[pfd->minor] = NULL;
 	mutex_unlock(&phone_lock);
 }
 




      Heute schon einen Blick in die Zukunft von E-Mails wagen? Versuchen Sie´s mit dem neuen Yahoo! Mail. www.yahoo.de/mail
