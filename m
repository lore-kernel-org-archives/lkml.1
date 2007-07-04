Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbXGDLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbXGDLsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbXGDLsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:48:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53732 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbXGDLsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:48:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 4 Jul 2007 07:45:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: finding "dead" CONFIG variables:  an ongoing 5-year mission ...
Message-ID: <Pine.LNX.4.64.0707040732230.5817@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as i'm sure a few folks are aware, i occasionally run a script to
scan the tree, looking for potentially "dead" CONFIG variables -- that
is, variables of the form CONFIG_FUBAR for which there is no
corresponding FUBAR in any Kconfig file.

  i know there are some cleanups queued for post-2.6.22, and i'm going
to run the script again after andrew releases what's queued in his
tree, but if anyone is interested in checking any part of the tree
before then, the script i use is here:

  http://fsdev.net/wiki/index.php?title=Misspelled_CONFIG_variables

  yes, it generates a number of false positives (would you folks
*please* stop using a prefix of "CONFIG_" for your non-Kconfig
variables??  argh. :-)  but sometimes the output is informative:


$ dead_config.sh fs
========== BEFS_RW ==========
fs/befs/linuxvfs.c:776:#ifndef CONFIG_BEFS_RW
fs/befs/linuxvfs.c:782:#endif                           /* CONFIG_BEFS_RW */
...
========== HAS_COMPAT_EPOLL_EVENT ==========
fs/compat.c:2112:#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
fs/compat.c:2155:#endif /* CONFIG_HAS_COMPAT_EPOLL_EVENT */
fs/compat.c:2182:#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
========== KDB_MODULES ==========
fs/xfs/linux-2.6/xfs_buf.h:414:#ifdef CONFIG_KDB_MODULES
fs/xfs/linux-2.6/xfs_buf.c:1871:#ifdef CONFIG_KDB_MODULES
========== NCPFS_DEBUGDENTRY ==========
fs/ncpfs/ncplib_kernel.c:729:#ifdef CONFIG_NCPFS_DEBUGDENTRY
========== XFS_DEBUG ==========
fs/xfs/xfs.h:21:#ifdef CONFIG_XFS_DEBUG
fs/xfs/Makefile-linux-2.6:23:ifeq ($(CONFIG_XFS_DEBUG),y)
... etc etc ...


$ dead_config.sh drivers
...
========== 68328_SERIAL_UART2 ==========
drivers/serial/68328serial.h:184:#ifndef CONFIG_68328_SERIAL_UART2
...
========== ALMA_ANS ==========
drivers/serial/68328serial.c:109:#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
...
========== BLK_DEV_MAC_MEDIABAY ==========
drivers/ide/legacy/macide.c:80:#ifdef CONFIG_BLK_DEV_MAC_MEDIABAY
drivers/ide/legacy/macide.c:131:#ifdef CONFIG_BLK_DEV_MAC_MEDIABAY
...

and on and on and tediously on.  i'll do a more complete run during
the next merge window, but feel free to check things out for yourself
before then.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
