Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXBYWJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXBYWJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXBYWJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:09:54 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:34527 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbXBYWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:09:53 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Feb 2007 17:07:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: second thoughts about DEPRECATED and OBSOLETE maturity levels
Message-ID: <Pine.LNX.4.64.0702251650580.29271@CPE00045a9c397f-CM001225dbafb6>
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


  having championed the cause of adding those two code maturity levels
to init/Kconfig, i just realized that implementing them as simple
dependencies has a *really* annoying shortcoming.

  in order to display that a kernel config feature is experimental,
developers have not only made that feature depend on EXPERIMENTAL, but
they've also had to *explicitly* add the trailer "(EXPERIMENTAL)" to
the prompt line in the Kconfig file, to make it visually obvious.

  obviously, it would be *way* nicer if that trailer were produced on
the fly for any "EXPERIMENTAL" feature, just as it would be for
OBSOLETE or DEPRECATED (or any other maturity levels people can dream
up).

  one solution is to hack Kconfig to look for specific dependencies
that represent maturity levels and add them automatically to those
respective lines.  doable, but kind of hacky.

  another solution is to add a new keyword like "status" or
"maturity", so that:

  config EXT4DEV_FS
        tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
        depends on EXPERIMENTAL
	...

becomes simply:

 config EXT4DEV_FS
        tristate "Ext4dev/ext4 extended fs support development"
        maturity EXPERIMENTAL
	...

internally, it could still be treated as a simple dependency, and
everything would still work.

  you know, this seemed so simple at first ...

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
