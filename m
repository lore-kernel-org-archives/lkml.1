Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXGILeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXGILeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXGILeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:34:10 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41080 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXGILeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:34:09 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 9 Jul 2007 07:32:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: technically, profile/oprofile Kconfig stuff is set up incorrectly
Message-ID: <Pine.LNX.4.64.0707090727300.17061@localhost.localdomain>
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


  as a short follow up to my previous patches, it might be worth
pointing out that profiling in general is defined improperly WRT
Kconfig, since *general* profiling is defined inside the more specific
Kconfig files for *oprofiling*:

  $ ls arch/*/oprofile/Kconfig

  that makes no sense, as it leads to incorrect Kconfig files like
arch/blackfin/oprofile/Kconfig:

=============================
menu "Profiling support"
depends on EXPERIMENTAL

config PROFILING
        bool "Profiling support (EXPERIMENTAL)"
        help
          Say Y here to enable the extended profiling support mechanisms used
          by profilers such as OProfile.

config OPROFILE
        tristate "OProfile system profiling (EXPERIMENTAL)"
        depends on PROFILING
        help
          OProfile is a profiling system capable of profiling the
          whole system, include the kernel, kernel modules, libraries,
          and applications.

          If unsure, say N.

config HARDWARE_PM
        tristate "Hardware Performance Monitor Profiling"
        depends on PROFILING
        help
          take use of hardware performance monitor to profiling the kernel
          and application.

          If unsure, say N.

endmenu
==========================

where non-oprofile content (HARDWARE_PM) is now defined within the
oprofile subdirectory.

  the whole selection of profiling really should be moved up a level,
with oprofile content as a subdirectory, or something similar.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
