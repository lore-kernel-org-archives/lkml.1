Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbZFLOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbZFLOdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZFLOdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:33:33 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8373 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZFLOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:33:32 -0400
X-IronPort-AV: E=Sophos;i="4.42,210,1243814400"; 
   d="scan'208";a="322477229"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Barnes\, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: mthca double free irqs
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Jun 2009 07:33:30 -0700
In-Reply-To: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 11 Jun 2009 19:45:21 -0700")
Message-ID: <adafxe51pz9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2009 14:33:30.0983 (UTC) FILETIME=[C1F41770:01C9EB6A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, can you try this with the ib_mthca module option
"msi_x=0" -- because I see

 > [  606.538429] ib_mthca 0000:c4:00.0: NOP command failed to generate
 > interrupt (IRQ 234).
 > [  606.543348] ib_mthca 0000:c4:00.0: Trying again with MSI-X disabled.

But perhaps the fallback to non-MSI-X in the driver is messing things
up.  Also you have:

 > [  606.222053] ib_mthca 0000:c4:00.0: HCA FW version 4.6.002 is old
 > (4.8.200 is current).

So updating the HCA firmware likely wouldn't hurt.

 - R.
