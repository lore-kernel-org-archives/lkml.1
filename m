Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYAHRnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYAHRnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYAHRnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:43:03 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:60383 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYAHRnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:43:01 -0500
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="7292022"
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20080108023222.GP23661@sgi.com>
	<1199809628.3534.34.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 Jan 2008 09:42:43 -0800
In-Reply-To: <1199809628.3534.34.camel@localhost.localdomain> (James Bottomley's message of "Tue, 08 Jan 2008 10:27:08 -0600")
Message-ID: <ada63y4kycs.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2008 17:42:43.0900 (UTC) FILETIME=[DF99FFC0:01C8521D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm already on record saying I don't think attributes in the generic
 > code is the right approach.  All of the attributes I can see adding are
 > bus specific (even to the extent that PCIe ones wouldn't apply to PCI
 > for instance).

I think the case before us that Arthur is dealing with is a
counterexample for this: there's nothing bus-specific about it all.
The issue is related to reordering of DMAs within the Altix system
fabric, after they've left the PCI world.  This issue would be present
no matter what kind of host bridge you hook up to the system fabric,
be it PCI-X, PCIe, ISA, MCA or whatever.

 - R.
