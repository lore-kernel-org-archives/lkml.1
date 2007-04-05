Return-Path: <linux-kernel-owner+w=401wt.eu-S1766555AbXDEXKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766555AbXDEXKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDEXK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:10:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbXDEXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:10:28 -0400
Date: Thu, 05 Apr 2007 16:10:27 -0700 (PDT)
Message-Id: <20070405.161027.115909479.davem@davemloft.net>
To: tony.luck@intel.com
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, mbligh@google.com, linux-mm@kvack.org,
       ak@suse.de, hansendc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] IA64: SPARSE_VIRTUAL 16M page size support
From: David Miller <davem@davemloft.net>
In-Reply-To: <617E1C2C70743745A92448908E030B2A0153594A@scsmsx411.amr.corp.intel.com>
References: <20070404230635.20292.81141.sendpatchset@schroedinger.engr.sgi.com>
	<617E1C2C70743745A92448908E030B2A0153594A@scsmsx411.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Thu, 5 Apr 2007 15:50:02 -0700

> Maybe a granule is not the right unit of allocation ... perhaps 4M
> would work better (4M/56 ~= 75000 pages ~= 1.1G)?  But if this is
> too small, then a hard-coded 16M would be better than a granule,
> because 64M is (IMHO) too big.

A 4MB chunk of page structs covers about 512MB of ram (I'm rounding up
to 64-bytes in my calculations and using an 8K page size, sorry :-).
So I think that is too small although on the sparc64 side that is the
biggest I have available on most processor models.

But I do agree that 64MB is way too big and 16MB is a good compromise
chunk size for this stuff.  That covers about 2GB of ram with the
above parameters, which should be about right.
