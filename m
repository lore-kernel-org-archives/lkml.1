Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZCZASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZCZASj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZCZAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:18:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46963
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbZCZASZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:18:25 -0400
Date: Wed, 25 Mar 2009 17:18:13 -0700 (PDT)
Message-Id: <20090325.171813.19940151.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Add support for the OpenCores 10/100 Mbps
 Ethernet MAC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237993027-12702-1-git-send-email-thierry.reding@avionic-design.de>
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de>
	<1237993027-12702-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Wed, 25 Mar 2009 15:57:07 +0100

> This patch adds a platform device driver that supports the OpenCores 10/100
> Mbps Ethernet MAC.
> 
> The driver expects three resources: one IORESOURCE_MEM resource defines the
> memory region for the core's memory-mapped registers while a second
> IORESOURCE_MEM resource defines the network packet buffer space. The third
> resource, of type IORESOURCE_IRQ, associates an interrupt with the driver.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Florian Fainelli <florian@openwrt.org>

I have some issues with the CONFIG_MII tests.

It seems better to just "select MII" in the Kconfig entry for this
driver.  So could you please do that instead?  I don't see how this
chip could possible work and obtain a link without the MII interface
being setup properly.

Besides, the ifdefs are ugly :-)

Other than this, the driver looks great.  Please fix up this MII
issue and I will add the driver to my tree.

Thanks!
