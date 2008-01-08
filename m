Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYAHRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYAHRzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbYAHRza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:55:30 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50693 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbYAHRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:55:27 -0500
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="32405012"
To: Christoph Hellwig <hch@infradead.org>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20080108023222.GP23661@sgi.com>
	<20080108175054.GA25168@infradead.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 Jan 2008 09:55:24 -0800
In-Reply-To: <20080108175054.GA25168@infradead.org> (Christoph Hellwig's message of "Tue, 8 Jan 2008 17:50:54 +0000")
Message-ID: <ada1w8skxrn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2008 17:55:24.0932 (UTC) FILETIME=[A5364440:01C8521F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Onething I've missed with these patches is drivers actually using
 > it.  What driver actually needs it and why don't you send patches
 > for them?

In previous patch series, Arthur sent fixes for the mthca IB driver.
Other IB drivers like mlx4 also need this on Altix systems.  Basically
anything where the device DMAs some data into userspace and then DMAs
a "completed" status to another buffer in userspace leads to a problem
where the "completed" DMA might pass the actual data in the Altix
fabric, which leads to the userspace process working with bogus data.

 - R.

