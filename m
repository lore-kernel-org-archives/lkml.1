Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbZDCLQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbZDCLQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbZDCLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:16:37 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:49606 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbZDCLQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QKzme6s55zWS/2wz9gbLsEmZGLNyaocn7envBwq/gstSj/M9HFuaIsTAPa8205ir7+
         aJCD5SMOkrW/CG4T4+1RyR8GfjpnbCsgANbrkH1C73TNZ+Bymssv1dsMDkF8ipSW6OJi
         iK6GbykCqXTHLWFdBWMzZTuOOBecE0FT5idy0=
Date: Fri, 3 Apr 2009 15:16:21 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: hp_sdc_rtc should depend on serio
Message-ID: <20090403111621.GA29023@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_SERIO is not set
hp_sdc_rtc.c:691: undefined reference to `hp_sdc_request_timer_irq'
and so on..

"select should be used with care. select will force
a symbol to a value without visiting the dependencies."

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/input/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 203abac..ae5d7dc 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -215,6 +215,7 @@ config INPUT_SGI_BTNS
 config HP_SDC_RTC
 	tristate "HP SDC Real Time Clock"
 	depends on GSC || HP300
+	select SERIO
 	select HP_SDC
 	help
 	  Say Y here if you want to support the built-in real time clock
