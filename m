Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbXBBJYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbXBBJYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXBBJYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:24:11 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:58326 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbXBBJYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:24:09 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 04:22:51 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: finding macro names that might need a "CONFIG_" prefix
Message-ID: <Pine.LNX.4.64.0702020410480.8570@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as another test, i wrote the following script:

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Misspelled_CONFIG_variables

that scans whatever part of the kernel source tree you want, and
locates macro names in preprocessor conditionals that might be
erroneously missing a "CONFIG_" prefix.

  as an example (and for no particular reason), let's pick on the
reiser file system:

$ bad_config.sh fs/reiserfs/
========== REISERFS_PROC_INFO ==========
fs/reiserfs/procfs.c:#if defined( REISERFS_PROC_INFO )
fs/reiserfs/procfs.c:/* REISERFS_PROC_INFO */
fs/reiserfs/procfs.c:/* REISERFS_PROC_INFO */
./fs/Kconfig:config REISERFS_PROC_INFO

that looks pretty clearly like someone should be testing
"CONFIG_REISERFS_PROC_INFO" rather than just "REISERFS_PROC_INFO", no?

  what about NTFS?

$ bad_config.sh fs/ntfs
========== NTFS_DEBUG ==========
fs/ntfs/attrib.c:#ifdef NTFS_DEBUG          <---  aha!
./fs/Kconfig:config NTFS_DEBUG
========== NTFS_RW ==========
fs/ntfs/logfile.h:#ifdef NTFS_RW            <--- another potential aha
fs/ntfs/logfile.h:#endif /* NTFS_RW */
... lots of dups removed ...
./fs/Kconfig:config NTFS_RW

  anyway, you get the idea.  have at it.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
