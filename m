Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbXGTTFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbXGTTFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXGTTFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:05:33 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:5726 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbXGTTFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:05:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAP6joEarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,563,1175497200"; 
   d="scan'208"; a="505509707:sNHT26481882"
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
       <jeff@garzik.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
X-Message-Flag: Warning: May contain useful information
References: <D5C1322C3E673F459512FB59E0DDC32903445CD4@orsmsx414.amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 12:05:24 -0700
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32903445CD4@orsmsx414.amr.corp.intel.com> (Waskiewicz Jr's message of "Fri, 20 Jul 2007 11:09:03 -0700")
Message-ID: <aday7hac2vf.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 19:05:25.0323 (UTC) FILETIME=[EDCA11B0:01C7CB00]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Both igb (recently posted) and ixgbe (also recently posted) support both
 > MSI and MSI-X.  Right now when we try to request MSI-X vectors, if we
 > fail to acquire what we've asked for, we fall back to MSI support.  If
 > MSI fails to initialize, we fall back to legacy interrupts.  So it needs
 > to be there in case MSI-X allocation fails for the NIC driver.

Hmm, I see I don't understand what this driver is doing.  What is a
"struct ioatdma_device"?  Is this driver requesting interrupts that
come from the NIC or the IOAT DMA engine?

Anyway, if the NICs support MSI-X, is there any chance of failing to
get one MSI-X vectors but then succeeding in getting MSI enabled?
How could that happen?  I don't see what falling back to MSI buys you
beyond more code.

 - R.
