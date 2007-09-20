Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXITRTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXITRTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXITRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:18:48 -0400
Received: from ns.suse.de ([195.135.220.2]:50647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbXITRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:18:47 -0400
Message-Id: <20070920171845.774383000@stravinsky.suse.de>
User-Agent: quilt/0.46-47.1
Date: Thu, 20 Sep 2007 19:18:45 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 0/7] Add extended crashkernel command line syntax
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a extended crashkernel syntax that makes the value of reserved
system RAM dependent on the system RAM itself:

    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end]

For example:

    crashkernel=512M-2G:64M,2G-:128M

The motivation comes from distributors that configure their crashkernel command
line automatically with some configuration tool (YaST, you know ;)). Of course
that tool knows the value of System RAM, but if the user removes RAM, then
the system becomes unbootable or at least unusable and error handling
is very difficult.

This series implements this change for i386, x86_64, ia64, ppc64 and sh. That
should be all platforms that support kdump in current mainline. I tested all
platforms except sh due to the lack of a sh processor.

The patch series is against 2.6.23-rc4-mm1.


Modifications compared to last submit:

  - put functions in __init
  - print message when no base address is specified on i386/x86_64/sh


Signed-off-by: Bernhard Walle <bwalle@suse.de>

-- 
