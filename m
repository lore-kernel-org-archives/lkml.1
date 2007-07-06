Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbXGFKkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbXGFKkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbXGFKkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:40:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58798 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbXGFKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:40:12 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 06:38:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can entire drivers/acorn subdirectory be removed?
Message-ID: <Pine.LNX.4.64.0707060632330.12604@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  given that:

1) drivers/Makefile doesn't even have an entry for the acorn/
   subdirectory, and

2) the Makefile drivers/acorn/char/Makefile is incorrect anyway, since
   it contains:

    obj-$(CONFIG_L7200_KEYB)        += defkeymap-l7200.o keyb_l7200.o

   which refers to a non-existent source file keyb_l7200.c, and it's
based on a non-existent config variable on top of that.  it certainly
seems that that entire subdirectory can be tossed.

  and if that happens, then the config variables defined in
drivers/acorn/block/Kconfig:

  config BLK_DEV_FD1772
  config BLK_DEV_MFM
  config BLK_DEV_MFM_AUTODETECT

would also vanish, which suggests that any references to *them* could
also be deleted:

$ grep -r BLK_DEV_FD1772 *
arch/arm26/defconfig:# CONFIG_BLK_DEV_FD1772 is not set
arch/arm26/machine/dma.c:#if defined(CONFIG_BLK_DEV_FD1772) || defined(CONFIG_BLK_DEV_FD1772_MODULE)
arch/arm26/machine/dma.c:#if defined(CONFIG_BLK_DEV_FD1772) || defined(CONFIG_BLK_DEV_FD1772_MODULE)
...

  anyway, you get the idea.  thoughts?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
