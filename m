Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbZJIDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbZJIDIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbZJIDIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:08:19 -0400
Received: from rtr.ca ([76.10.145.34]:50000 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbZJIDIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:08:18 -0400
Message-ID: <4ACEA8FB.4060901@rtr.ca>
Date: Thu, 08 Oct 2009 23:07:39 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard>	 <1254879618.1471.525.camel@giskard>  <4ACC076F.7020000@rtr.ca> <1255020134.30440.698.camel@giskard>
In-Reply-To: <1255020134.30440.698.camel@giskard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti wrote:
>
> I want to try reducing the frequency of the PCI-X bus, but the BIOS does
> not seem to provide a setting for it.  Is there another way?
..

Nothing that's easy.

Here.. apply this patch, and post the output after you reboot with it.


--- 2.6.31/drivers/ata/sata_mv.c.orig	2009-08-21 22:16:05.000000000 -0400
+++ linux/drivers/ata/sata_mv.c	2009-10-08 23:05:37.392203506 -0400
@@ -3738,6 +3738,12 @@
 			hp_flags |= MV_HP_ERRATA_60X1B2;
 			break;
 		case 0x9:
+		{
+			struct mv_host_priv *hpriv = host->private_data;
+			void __iomem *mmio = hpriv->base;
+			printk(KERN_INFO "sata_mv: pcix_mode=%d\n", mv_in_pcix_mode(host));
+			printk(KERN_INFO "sata_mv: MV_PCI_COMMAND=%08x\n", readl(mmio + MV_PCI_COMMAND);
+		}
 			hp_flags |= MV_HP_ERRATA_60X1C0;
 			break;
 		default:
