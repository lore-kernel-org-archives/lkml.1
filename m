Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYJNCAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYJNCAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYJNCAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:00:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42645
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYJNCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:00:38 -0400
Date: Mon, 13 Oct 2008 19:00:14 -0700 (PDT)
Message-Id: <20081013.190014.239477645.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com
Subject: Re: [PATCH] dsa: fix compile bug on s390
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013090418.GB17793@osiris.boeblingen.de.ibm.com>
References: <20081013090418.GB17793@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 13 Oct 2008 11:04:18 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> git commit 45cec1bac0719c904bb5f4405c2937f7e715888c
> "dsa: Need to select PHYLIB." causes this build bug on s390:
> 
> drivers/built-in.o: In function `phy_stop_interrupts':
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:631: undefined reference to `free_irq'
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:646: undefined reference to `enable_irq'
> drivers/built-in.o: In function `phy_start_interrupts':
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:601: undefined reference to `request_irq'
> drivers/built-in.o: In function `phy_interrupt':
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:528: undefined reference to `disable_irq_nosync'
> drivers/built-in.o: In function `phy_change':
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:674: undefined reference to `enable_irq'
> /home/heicarst/linux-2.6/drivers/net/phy/phy.c:692: undefined reference to `disable_irq'
> 
> PHYLIB has alread a depend on !S390, however select PHYLIB at DSA overrides
> that unfortunately. So add a depend on !S390 to DSA as well.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied.

It's not pretty but the alternatives aren't any better.

I wonder if we should instead make PHYLIB a dependency here, but
that of course exposes implementation details to the user that
they shouldn't need to be concerned about when they want to
enable a certain feature.
