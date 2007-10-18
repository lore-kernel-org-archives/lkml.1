Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbXJRAlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbXJRAlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbXJRAlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:41:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:12835 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbXJRAln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="249643802"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/5] I/OAT: Tighten descriptor setup performance
Date: Wed, 17 Oct 2007 17:41:41 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C033FE99D@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071017173421.2995d0b9.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5] I/OAT: Tighten descriptor setup performance
Thread-Index: AcgRHqHWkBL2eHeaQiiJSbfRDaEkdAAAJ/pA
References: <20071018001416.31147.86176.stgit@localhost.localdomain><20071018001433.31147.43339.stgit@localhost.localdomain> <20071017173421.2995d0b9.akpm@linux-foundation.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>, <randy.dunlap@oracle.com>
X-OriginalArrivalTime: 18 Oct 2007 00:41:42.0434 (UTC) FILETIME=[A70CA020:01C8111F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>
>On Wed, 17 Oct 2007 17:14:33 -0700
>Shannon Nelson <shannon.nelson@intel.com> wrote:
>
>> The change to the async_tx interface cost this driver some 
>performance by
>> spreading the descriptor setup across several functions, 
>including multiple
>> passes over the new descriptor chain.  Here we bring the 
>work back into one
>> primary function and only do one pass.
>> 
>> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>> ---
>> 
>>  drivers/dma/ioat_dma.c |  170 
>+++++++++++++++++++++++++-----------------------
>>  drivers/dma/ioatdma.h  |    6 +-
>>  2 files changed, 93 insertions(+), 83 deletions(-)
>> 
>> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
>> index c44f551..117ac38 100644
>> --- a/drivers/dma/ioat_dma.c
>> +++ b/drivers/dma/ioat_dma.c
>> @@ -46,9 +46,12 @@
>>  /* internal functions */
>>  static void ioat_dma_start_null_desc(struct ioat_dma_chan 
>*ioat_chan);
>>  static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan 
>*ioat_chan);
>> +static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
>> +					      struct 
>ioat_dma_chan *ioat_chan);
>
>A forward-declared static inline is pretty weird.  Does gcc 
>actually do the
>right thing with it?

Well, I didn't inspect the opcodes generated...

>
>This function is far too large to be inlined anyway.
>

No prob, I can remove the "inline" and repost.

sln
