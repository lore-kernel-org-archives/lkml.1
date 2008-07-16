Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYGPUfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYGPUfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYGPUfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:35:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41109
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbYGPUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:35:30 -0400
Date: Wed, 16 Jul 2008 13:35:29 -0700 (PDT)
Message-Id: <20080716.133529.131285284.davem@davemloft.net>
To: matthew@wil.cx
Cc: jbarnes@virtuousgeek.org, david.vrabel@csr.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: PCI: MSI interrupts masked using prohibited method
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080716195853.GL25255@parisc-linux.org>
References: <200806271007.26248.jbarnes@virtuousgeek.org>
	<200807161243.03360.jbarnes@virtuousgeek.org>
	<20080716195853.GL25255@parisc-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Wed, 16 Jul 2008 13:58:53 -0600

> David's clearly talking about devices which don't support mask bits.
> For these devices, we call
>                         msi_set_enable(entry->dev, !flag);
> 
> which turns off the PCI_MSI_FLAGS_ENABLE bit.  I'm not sure I see the
> bit in the PCI spec that says devices are then allowed to ignore the
> Interrupt Disable bit in the device control register, but I concede such
> devices may be out there.

Keep in mind also the msi intx disable bug we already have
workarounds for.  It shows that there are tons of questionable
behavior in this area.

