Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZHDWPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZHDWPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZHDWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:15:00 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:61134 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZHDWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:14:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMNPeEqrR7O6/2dsb2JhbAC8N4gpkBcFhBg
X-IronPort-AV: E=Sophos;i="4.43,324,1246838400"; 
   d="scan'208";a="223420803"
Date: Tue, 4 Aug 2009 15:14:59 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 0/7] initdev:kernel:Introduction to initdev synchronization
	patchset
Message-ID: <20090804221459.GA9085@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel command line parameters "ip", "root", and "console" take devices
as arguments. These are termed "init devices" since devices specified by
these parameters are used during kernel initialization. Some init devices
take a long time to be discovered and made ready for use, USB devices being
a prime example. This patch provides two, related, functionalities:

o	Wait for device setup. Provides synchronization between use of
	init devices and their setup so that attempts to use them can be
	delayed until the devices are ready.
o	Prompt device wait termination. Terminates waits for device
	discovery as soon as it is know that no more devices remain to be
	discovered. For example, consider an embedded device that may or
	may not have a USB console. As soon as all USB devices have been
	discovered, there is no more need to wait for a console that isn't
	attached, and a headless system boot can continue.

This patch supports device discovery on USB and SCSI buses but provides a
framework for other bus types. Where possible, specific device types can
be specified so that, for example, waiting on a console does not prevent
mounting a root filesystem.

A secondary consequence of this patch is that the only remaining use of the
rootwait kernel parameter is to wait for a root device that is not plugged
in at boot.

This introduction is followed by 7 small-ish patches. It would be possible
to combine these but this patch touches the console, networking, and block
device areas and it is hoped that splitting the changes into smaller,
targeted chunks will make it easier for people in those areas to review it.
1	Basic initdev infrastructure
2	USB device discovery notification
3	Wait for console
4	Wait for network devices
5	USB and SCSI block device notification
6	Additional SCSI block device notification for asynchronous function
7	Wait for block device used for root

(Many thanks to Alan Stern, who said we could solve this without offensive
timeouts and then set about doing the integration into core USB and SCSI
code)

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---

