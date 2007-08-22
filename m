Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXHVVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXHVVEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbXHVVE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:04:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:43376 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbXHVVEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,295,1183359600"; 
   d="scan'208";a="120396188"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Date: Wed, 22 Aug 2007 14:04:22 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46CC811C.9010600@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Thread-Index: Acfk6sMGn7PUZ2pTRICSHh/+xfMfwgAEn3tQ
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andi Kleen" <ak@suse.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 22 Aug 2007 21:04:23.0209 (UTC) FILETIME=[03EEC990:01C7E500]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Attached the boot log and config file.

Kamelesh,

I don't see anything obvious in the boot_log.

I used your "dotconfig" file to build a 2.6.23-rc3-mm1 kernel
and booted it on my test system ... it worked just fine
(except that for some reason the network did not come up :-( )

I tried to compare my boot log with yours ... you have some
different devices (E.g. your ethernet links are Tigon3 while
mine are e1000) ... so the memory leak in a driver theory
is a possibility.

Try adding a dump_stack() call to lib/swiotlb.c where the
"DMA: Out of SW-IOMMU space ..." message is printed.  That
would tell us who is making the call that fails (they
might be an innocent bystander after someone else has
used all the space ... but this is unlikely).

-Ton
