Return-Path: <linux-kernel-owner+w=401wt.eu-S1751148AbXEaXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbXEaXRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXEaXRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:17:08 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:8112 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXEaXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:17:07 -0400
X-IronPort-AV: i="4.16,371,1175497200"; 
   d="scan'208"; a="489770076:sNHT43947206"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
X-Message-Flag: Warning: May contain useful information
References: <465C188F.9000900@googlemail.com>
	<465C22F4.8080505@googlemail.com>
	<alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
	<20070531220833.GA10867@beardog.cca.cpqcorp.net>
	<alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
	<20070531223908.GA12325@beardog.cca.cpqcorp.net>
	<20070531155018.a8226075.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0705311610440.26602@woody.linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 31 May 2007 16:17:00 -0700
In-Reply-To: <alpine.LFD.0.98.0705311610440.26602@woody.linux-foundation.org> (Linus Torvalds's message of "Thu, 31 May 2007 16:12:02 -0700 (PDT)")
Message-ID: <adalkf4oa6r.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 May 2007 23:17:00.0761 (UTC) FILETIME=[CAB79C90:01C7A3D9]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What about the changes to fix the order that MSI-X irqs are returned
in (iirc, list_add had to be changed to list_add_tail in a couple of
places).  Without that change, multiple MSI-X interrupts seem to be
broken: the kernel programs the MSI-X table in the opposite order that
it gives the irq numbers to the driver.  The net effect is that if I
request, say, 3 MSI-X interrupts for a device, then when the device
generates the first interrupt, the driver thinks it generated the
third interrupt, and things go fairly haywire.

 - R.
