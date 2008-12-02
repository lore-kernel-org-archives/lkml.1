Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYLBEcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYLBEcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLBEb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:31:56 -0500
Received: from hpsmtp-eml11.KPNXCHANGE.COM ([213.75.38.111]:36294 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYLBEbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:31:55 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 05:31:50 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812011933050.3256@nehalem.linux-foundation.org>
In-reply-To: <alpine.LFD.2.00.0812011933050.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812020531.53175.elendil@planet.nl>
X-OriginalArrivalTime: 02 Dec 2008 04:31:53.0697 (UTC) FILETIME=[E6FB5D10:01C95436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, btw, one more thing: since it apparently sometimes _does_ resume
> from hibernation without all this, I'd also like to see the actual
> differences in /proc/ioports and /proc/iomem that happen as a result of
> the different alignment.

You're in luck. I still had /proc/io* contents from .28-rc3 lying around 
from working on some other issue.

Here's the relevant diff for iomem; there's no diff for ioports.

--- iomem_2.6.28-rc3    2008-11-03 10:59:37.000000000 +0100
+++ iomem_2.6.28-rc6_linus      2008-12-02 05:20:31.000000000 +0100
@@ -10,10 +10,9 @@
 7e7b0000-7e7c53ff : reserved
 7e7c5400-7e7e7fb7 : ACPI Non-volatile Storage
 7e7e7fb8-7effffff : reserved
-80000000-83ffffff : PCI Bus 0000:02
-  80000000-83ffffff : PCI CardBus 0000:03
-84000000-87ffffff : PCI CardBus 0000:03
-88000000-88000fff : Intel Flush Page
+80000000-83ffffff : PCI CardBus 0000:03
+84000000-84000fff : Intel Flush Page
+84400000-847fffff : PCI CardBus 0000:03
 d0000000-dfffffff : 0000:00:02.0
   d0000000-d076ffff : vesafb
 e0000000-e00fffff : PCI Bus 0000:10

I've tried a few quick suspend/resume cycles and no failures so far, but 
that's not really conclusive yet.

Besides snd_hda_intel I've also been unloading e1000e before suspend 
because I thought it contributed to resume failures. I'm now keeping that 
loaded as well. Will report results.

Cheers,
FJP
