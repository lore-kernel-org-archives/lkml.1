Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZFLQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZFLQeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764926AbZFLQZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:36 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:23982 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764905AbZFLQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:35 -0400
X-IronPort-AV: E=Sophos;i="4.42,210,1243814400"; 
   d="scan'208";a="199114590"
From: Roland Dreier <rdreier@cisco.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "general\@lists.openfabrics.org" <general@lists.openfabrics.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mthca double free irqs
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	<adafxe51pz9.fsf@cisco.com> <20090612085053.0fbe9731@jbarnes-g45>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Jun 2009 09:25:36 -0700
In-Reply-To: <20090612085053.0fbe9731@jbarnes-g45> (Jesse Barnes's message of
	"Fri, 12 Jun 2009 08:50:53 -0700")
Message-ID: <ada4oul1ksf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2009 16:25:36.0898 (UTC) FILETIME=[6AE94620:01C9EB7A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > My linux-next branch has a change to the return value from the MSI-X
 > allocation function: pci_enable_msix now returns the number of
 > available entries rather than -EINVAL if the allocation failed.  Would
 > that cause problems in the mthca driver?

I don't think so in this case ... the driver is getting past enabling
MSI-X and actually testing the interrupt before it fails.  I'll audit
the code just to make sure we handle that case though.  But I thought
pci_enable_msix() always returned the number of entries actually
available if the allocation failed?

 - R.
