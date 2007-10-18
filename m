Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbXJRAxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbXJRAxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXJRAxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:53:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:25828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbXJRAxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:53:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="300576919"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] I/OAT: Add completion callback for async_tx interface use
Date: Wed, 17 Oct 2007 17:53:00 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C033FE9B1@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071017.174756.74746737.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] I/OAT: Add completion callback for async_tx interface use
Thread-Index: AcgRILBKQ9DxQT1pSViyf5tbDduPcgAAGTFw
References: <20071018001416.31147.86176.stgit@localhost.localdomain><20071018001439.31147.52329.stgit@localhost.localdomain><20071017174438.f0d6fe2e.akpm@linux-foundation.org> <20071017.174756.74746737.davem@davemloft.net>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "David Miller" <davem@davemloft.net>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>, <randy.dunlap@oracle.com>
X-OriginalArrivalTime: 18 Oct 2007 00:53:01.0778 (UTC) FILETIME=[3BF84B20:01C81121]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Miller [mailto:davem@davemloft.net] 
>
>From: Andrew Morton <akpm@linux-foundation.org>
>Date: Wed, 17 Oct 2007 17:44:38 -0700
>
>> On Wed, 17 Oct 2007 17:14:39 -0700
>> Shannon Nelson <shannon.nelson@intel.com> wrote:
>> 
>> > +	tx->callback = (void *)ioat_dma_test_callback;
>> 
>> and when I remove this cast I get
>> 
>> drivers/dma/ioat_dma.c: In function 'ioat_dma_self_test':
>> drivers/dma/ioat_dma.c:718: warning: assignment from 
>incompatible pointer type
>> 
>> because ioat_dma_test_callback isn't void-returning.  
>Something is wrong
>> here.  I assume that ioat_dma_test_callback() should just be
>> void-returning?
>
>In fact this might crash on systems that conditionally pop
>return values based upon whether the function is void or not.
>

Yep - thanks.  That's my misuse of Dan's dma_async_tx_callback typedef.

sln
