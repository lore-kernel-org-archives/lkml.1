Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYEQKE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYEQKE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 06:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYEQKEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 06:04:45 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60111 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYEQKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 06:04:44 -0400
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <200805161906.19321.toralf.foerster@gmx.de>
References: <200805161906.19321.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 17 May 2008 11:04:31 +0100
Message-Id: <1211018673.3603.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 19:06 +0200, Toralf Förster wrote:
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1

There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
the user =y.

This should fix it.

James

---

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..6c7eff2 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -13,7 +13,7 @@ struct firmware {
 
 struct device;
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(


