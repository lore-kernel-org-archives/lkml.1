Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbXBYHuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbXBYHuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 02:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXBYHuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 02:50:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58198
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933674AbXBYHuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 02:50:22 -0500
Date: Sat, 24 Feb 2007 23:50:20 -0800 (PST)
Message-Id: <20070224.235020.92583817.davem@davemloft.net>
To: ebiederm@xmission.com
CC: linux-kernel@vger.kernel.org
Subject: MSI entry unlinked before arch_teardown_msi_irq().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Eric, you recommended to me that I use:

	struct msi_desc *entry = get_irq_data(irq);

in my arch_teardown_msi_irq() routine earlier, but the current
code unlinks the entry before the call to arch_teardown_msi_irq()
so I get OOPS's on shutdown on sparc64 because of this since
get_irq_data() will return NULL at that point.

Can you fix this up or suggest how I should code the patch to
your liking so I can take care of it?

Thanks!
