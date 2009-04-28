Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZD1RZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZD1RZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZD1RYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:24:50 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:43113 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896AbZD1RYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:24:49 -0400
Date: Tue, 28 Apr 2009 19:24:42 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] CRISv32: Fix typo compile error in ARTPEC-3 gpio driver.
Message-ID: <20090428172442.GP21811@axis.com>
References: <alpine.LFD.2.00.0904261952510.1991@localhost.localdomain> <4BEA3FF3CAA35E408EA55C7BE2E61D053B089B66DD@xmail3.se.axis.com> <alpine.LFD.2.00.0904270711040.5689@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904270711040.5689@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 01:11:39PM +0200, Robert P. J. Day wrote:
> On Mon, 27 Apr 2009, Mikael Starvik wrote:
> >   should that not be "spin_unlock_irqrestore()"?
> 
>   um ... the code is correct, or my observation is correct?  in any
> event, i'll leave this with you.

Hi, I've just added the following patch to the CRIS-tree:

=============
Subject: [PATCH] CRISv32: Fix typo compile error in ARTPEC-3 gpio driver.

arch/cris/arch-v32/drivers/mach-a3/gpio.c:
+spin_lock_irqrestore(&gpio_lock, flags);
arch/cris/arch-v32/drivers/mach-a3/gpio.c:
+spin_lock_irqrestore(&gpio_lock, flags);

  should that not be "spin_unlock_irqrestore()"?

The code in question was inside an (most often) undefined ifdef.

Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 7a87bc0..97357cf 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -681,7 +681,7 @@ static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
 		shadow |= ~readl(dir_oe[priv->minor]) |
 			(arg & changeable_bits[priv->minor]);
 		i2c_write(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
-		spin_lock_irqrestore(&gpio_lock, flags);
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_CLRBITS:
 		spin_lock_irqsave(&gpio_lock, flags);
@@ -690,7 +690,7 @@ static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
 		shadow |= ~readl(dir_oe[priv->minor]) &
 			~(arg & changeable_bits[priv->minor]);
 		i2c_write(VIRT_I2C_ADDR, (void *)&shadow, sizeof(shadow));
-		spin_lock_irqrestore(&gpio_lock, flags);
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_HIGHALARM:
 		/* Set alarm when bits with 1 in arg go high. */
-- 
1.6.1


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
