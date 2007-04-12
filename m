Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXDLX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXDLX2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDLX2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:28:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39387 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbXDLX2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:28:42 -0400
X-IronPort-AV: i="4.14,405,1170662400"; 
   d="scan'208"; a="135252135:sNHT48062457"
To: CaT <cat@zip.com.au>
Cc: Michael Chan <mchan@broadcom.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: intermittant petabyte usage reported with broadcom nic
X-Message-Flag: Warning: May contain useful information
References: <20070402014319.GA8345@zip.com.au>
	<20070402001300.3b66007d.akpm@linux-foundation.org>
	<20070412225249.GU8345@zip.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 16:28:37 -0700
In-Reply-To: <20070412225249.GU8345@zip.com.au> (cat@zip.com.au's message of "Fri, 13 Apr 2007 08:52:49 +1000")
Message-ID: <adak5whdvfe.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 23:28:37.0731 (UTC) FILETIME=[4BE70B30:01C77D5A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Michael Chan, who seems to look after bnx2, to the cc list]

 > To clarify it's an Intel Dual Core Xeon (I just wound up as thinking of
 > them all as amd64s). Network card driver in use is the one defined by
 > CONFIG_BNX2. Kernel's monolithic.

>From a quick look at bnx2.c, it seems that the driver gives the NIC
(firmware?) a block of memory to DMA stats into, and just reads from
that memory in its get_stats method.  So if you're seeing wonky stats
from the NIC intermittently, my best guess would be that firmware is
occasionally writing junk into the stats block.

 - R.
