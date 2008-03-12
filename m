Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYCLVMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYCLVMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYCLVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:11:53 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:42837 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYCLVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:11:52 -0400
Message-ID: <47D8473A.3060806@keyaccess.nl>
Date: Wed, 12 Mar 2008 22:12:26 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Michael Cree <mcree@orcon.net.nz>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080312203150.80E01DBA2@gherkin.frus.com>
In-Reply-To: <20080312203150.80E01DBA2@gherkin.frus.com>
Content-Type: multipart/mixed;
 boundary="------------060507080809010502060906"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060507080809010502060906
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 12-03-08 21:31, Bob Tracy wrote:

> Here is the requested list of CONFIG_ALPHA_* items for the
> 2.6.25-rc4+iommu_patch kernel with support for snd-es18xx and snd-sb8:
> 
> CONFIG_ALPHA=y
> CONFIG_ALPHA_MIATA=y
> CONFIG_ALPHA_EV5=y
> CONFIG_ALPHA_CIA=y
> CONFIG_ALPHA_EV56=y
> CONFIG_ALPHA_PYXIS=y
> CONFIG_ALPHA_SRM=y
> CONFIG_ALPHA_LEGACY_START_ADDRESS=y
> 
>>From arch/alpha/kernel/Makefile, obj-${CONFIG_ALPHA_MIATA} adds es1888.o
> as a built-in object, so yes, it's built-in.

Okay, and applying the attached just makes your sound completely dead in the 
water?

> I never noticed the init support for the ES1888 chip before...  The code
> appears to set up DMA channel 1, but does not mention anything about the
> second 16-bit DMA channel.

Indeed. It seems to init it as an sb8...

Rene.


--------------060507080809010502060906
Content-Type: text/plain;
 name="alpha_miata_no_es1888.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="alpha_miata_no_es1888.diff"

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index dccf052..f53a3a2 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -77,7 +77,7 @@ obj-$(CONFIG_ALPHA_EIGER)	+= sys_eiger.o irq_i8259.o
 obj-$(CONFIG_ALPHA_JENSEN)	+= sys_jensen.o pci-noop.o irq_i8259.o
 obj-$(CONFIG_ALPHA_MARVEL)	+= sys_marvel.o 
 obj-$(CONFIG_ALPHA_MIATA)	+= sys_miata.o irq_pyxis.o irq_i8259.o \
-				   es1888.o smc37c669.o
+				   smc37c669.o
 obj-$(CONFIG_ALPHA_MIKASA)	+= sys_mikasa.o irq_i8259.o irq_srm.o
 obj-$(CONFIG_ALPHA_NAUTILUS)	+= sys_nautilus.o irq_i8259.o irq_srm.o
 obj-$(CONFIG_ALPHA_NORITAKE)	+= sys_noritake.o irq_i8259.o
diff --git a/arch/alpha/kernel/sys_miata.c b/arch/alpha/kernel/sys_miata.c
index 910b43c..5601d7e 100644
--- a/arch/alpha/kernel/sys_miata.c
+++ b/arch/alpha/kernel/sys_miata.c
@@ -236,7 +236,6 @@ miata_init_pci(void)
 {
 	cia_init_pci();
 	SMC669_Init(0); /* it might be a GL (fails harmlessly if not) */
-	es1888_init();
 }
 
 static void

--------------060507080809010502060906--
