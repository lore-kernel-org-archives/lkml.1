Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAASET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAASET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYAASEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:04:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYAASEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:04:09 -0500
Date: Tue, 1 Jan 2008 19:04:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
In-Reply-To: <20080101143022.664e8894@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0801011858350.14900@fbirervta.pbzchgretzou.qr>
References: <20080101134809.GK2360@does.not.exist> <20080101142623.GA3592@elte.hu>
 <20080101143022.664e8894@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 1 2008 14:30, Alan Cox wrote:
>> * Adrian Bunk <bunk@kernel.org> wrote:
>> 
>> > This patch removes the EXPERIMENTAL option and all dependencies on 
>> > EXPERIMENTAL since they are pointless.
>> 
>> agreed. CONFIG_BROKEN has real use - but CONFIG_EXPERIMENTAL is pretty 
>> pointless in the 90-days kernel development model.
>
>Then I need a replacement equivalent for the ATA layer and all the other
>drivers using it to indicate stuff that *IS* experimental, or not yet
>known to be highly robust. [...]
>
>CONFIG_ATA_EXPERIMENTAL, CONFIG_NET_EXPERIMENTAL,
>CONFIG_VIDEO_EXPERIMENTAL, ... all being added by developers

Yes please.


menuconfig actually supports placing config options in more than one
place, would this be helpful? (besides the itch that it is defined in 
two places.)

---
 drivers/ata/Kconfig |    5 +++++
 init/Kconfig        |    8 ++++++++
 2 files changed, 13 insertions(+)

Index: linux-2.6_nosov/drivers/ata/Kconfig
===================================================================
--- linux-2.6_nosov.orig/drivers/ata/Kconfig
+++ linux-2.6_nosov/drivers/ata/Kconfig
@@ -23,6 +23,11 @@ menuconfig ATA
 
 if ATA
 
+# also see init/Kconfig
+config ATA_EXPERIMENTAL
+	bool "Prompt for experimental libata drivers"
+	depends on EXPERIMENTAL
+
 config ATA_NONSTANDARD
        bool
        default n
Index: linux-2.6_nosov/init/Kconfig
===================================================================
--- linux-2.6_nosov.orig/init/Kconfig
+++ linux-2.6_nosov/init/Kconfig
@@ -40,6 +40,14 @@ config EXPERIMENTAL
 	  you say Y here, you will be offered the choice of using features or
 	  drivers that are currently considered to be in the alpha-test phase.
 
+if EXPERIMENTAL
+
+# also see drivers/ata/Kconfig
+config ATA_EXPERIMENTAL
+	bool "Prompt for experimental libata drivers"
+
+endif # EXPERIMENTAL
+
 config BROKEN
 	bool
 
