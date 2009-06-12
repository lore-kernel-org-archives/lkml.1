Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZFLQek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZFLQek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765350AbZFLQ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:26:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8129 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765331AbZFLQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:26:18 -0400
X-IronPort-AV: E=Sophos;i="4.42,210,1243814400"; 
   d="scan'208";a="322544671"
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
Date: Fri, 12 Jun 2009 09:26:19 -0700
In-Reply-To: <20090612085053.0fbe9731@jbarnes-g45> (Jesse Barnes's message of
	"Fri, 12 Jun 2009 08:50:53 -0700")
Message-ID: <adazlcdzadw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2009 16:26:19.0804 (UTC) FILETIME=[847C35C0:01C9EB7A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, the code as it is should be OK:

	err = pci_enable_msix(mdev->pdev, entries, ARRAY_SIZE(entries));
	if (err) {
		if (err > 0)
			mthca_info(mdev, "Only %d MSI-X vectors available, "
				   "not using MSI-X\n", err);
		return err;
	}

 - R.
