Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbYBGUNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbYBGUNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbYBGULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:11:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:43050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761669AbYBGULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,317,1199692800"; 
   d="scan'208";a="514985206"
Date: Thu, 7 Feb 2008 12:02:52 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: issue with patch "x86: no CPA on iounmap"
Message-ID: <20080207200251.GA21564@linux-os.sc.intel.com>
References: <20080205011357.GA14712@linux-os.sc.intel.com> <47A7EA88.3020404@linux.intel.com> <20080205070535.GA10695@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205070535.GA10695@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 08:05:35AM +0100, Ingo Molnar wrote:
> there are many GART drivers, and the method used depends on the GART 
> driver. The following GART drivers still use ioremap in one way or 
> another:

There is another issue I see in the recent pageattr changes, again in the GART
driver context.

GART drivers use map_page_into_agp() and unmap_page_from_agp() during
runtime (and not just during load and unload of the driver module). In the
recent pageattr changes, we seem to have dropped the concept of reverting
to the large page(for the kernel identity mapping) while changing the attribute
back to WB. In this GART driver context, over the time, potentially
kernel identity mappings might be backed by small pages, if we don't
revert to large page again during set_memory_wb() which gets called during
unmap_page_from_agp() for a RAM page. And thus loosing the advantage of large
page mapping for kernel identity mappings.

thanks,
suresh
