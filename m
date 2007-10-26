Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXJZMHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXJZMHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXJZMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:07:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39867 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXJZMHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:07:38 -0400
Date: Fri, 26 Oct 2007 08:04:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: finding unused Kconfig variables in the source tree
Message-ID: <Pine.LNX.4.64.0710260755340.17687@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as i mentioned in an earlier post, i threw together a quick script
that scans the source tree, not for dead CONFIG vars (those that are
checked but never defined in a Kconfig file) but for the exact
opposite -- those that are *defined* in a Kconfig file but are
apparently never used anywhere.

  for example (since the CRIS architecture came up recently), here's
the first few lines of output (the script is still running as we
speak):

$ ../find_unused_configs.sh arch/cris
>>>>> ETRAX_ETHERNET_HW_CSUM
arch/cris/arch-v32/drivers/Kconfig:config ETRAX_ETHERNET_HW_CSUM
>>>>> ETRAX_ETHERNET_IFACE0
arch/cris/arch-v32/drivers/Kconfig:config ETRAX_ETHERNET_IFACE0
...

  that tells me that, unless i've completely screwed my programming, a
Kconfig file defines the variable ETRAX_ETHERNET_HW_CSUM, which is
subsequently never referenced by anything anywhere in the tree.
(that would normally suggest a feature that was removed from the tree
without removing its controlling CONFIG variable.)

  i'll run this on bits of the tree at a time and send the results to
the appropriate people, at which point they can do what they want in
terms of cleaning Kconfig files.

rday

p.s.  perhaps one of the CRIS folks could verify that those variables
are, in fact, unused, so i know i haven't screwed something up
horribly.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
