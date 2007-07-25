Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbXGYMjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbXGYMjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXGYMjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:39:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbXGYMjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:39:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: YOSHIFUJI Hideaki /
	 =?utf-8?q?=E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E?= 
	<yoshfuji@linux-ipv6.org>
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
Date: Wed, 25 Jul 2007 14:46:55 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070724.171917.30313741.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070724.171917.30313741.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707251446.56809.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 25 July 2007 00:19, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> Hello.
> 
> Linux 2.6.23-rc1 fails to power off my ThinkPad T42.
> Git-bisect told me that the following commit is to blame,
> and by reverting that commit, it works appropriately.

(1) Can you please apply the appended patch and see if the message gets
    printed when you try to power off the system?

(2) Can you please post your .config? 

Greetings,
Rafael


---
 drivers/acpi/sleep/poweroff.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23-rc1/drivers/acpi/sleep/poweroff.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/acpi/sleep/poweroff.c
+++ linux-2.6.23-rc1/drivers/acpi/sleep/poweroff.c
@@ -42,6 +42,7 @@ int acpi_sleep_prepare(u32 acpi_state)
 static void acpi_power_off_prepare(void)
 {
 	/* Prepare to power off the system */
+	printk(KERN_EMERG "ACPI: Preparing to power off the system\n");
 	acpi_sleep_prepare(ACPI_STATE_S5);
 }
 
