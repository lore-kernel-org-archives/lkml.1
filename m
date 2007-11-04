Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbXKDQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbXKDQLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXKDQLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:11:15 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:26410 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXKDQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:11:14 -0500
X-IronPort-AV: E=Sophos;i="4.21,368,1188802800"; 
   d="scan'208";a="14530251"
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
X-Message-Flag: Warning: May contain useful information
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 04 Nov 2007 08:11:10 -0800
In-Reply-To: <1194168583.10245.15.camel@rukbat> (Romano Giannetti's message of "Sun, 04 Nov 2007 10:29:43 +0100")
Message-ID: <ada8x5ec7oh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Nov 2007 16:11:11.0033 (UTC) FILETIME=[50BF4290:01C81EFD]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had something similar recently, trying to access an SD card in the
internal drive of my thinkpad X60.  Fortunately, the data wasn't
actually corrupted, but when I tried to copy the picture files off the
card, I saw garbage filenames in the picture directory, and I saw this
in the kernel log:

    [84797.855013] mmc0: new SD card at address b368
    [84798.227299] mmcblk0: mmc0:b368 SD    501248KiB 
    [84798.227541]  mmcblk0: p1
    [84810.378736] FAT: Filesystem panic (dev mmcblk0p1)
    [84810.378748]     invalid access to FAT (entry 0x0000bfff)
    [84810.378753]     File system has been set read-only
    [84810.378812] FAT: Filesystem panic (dev mmcblk0p1)
    [84810.378816]     invalid access to FAT (entry 0x0000ffbf)

(and on quite a bit longer)

When I put the same card back in the camera and used the camera's dock
to access the data via USB mass storage, everything worked fine.  So
it does seem to be at least somewhat MMC-related.

Please let me know if there's further debug info that might be
helpful... this problem seems to be completely reproducible on my
system.  I'm running a post 2.6.24-rc1 git tree
(v2.6.24-rc1-521-g54866f0 according to git describe).

 - R.
