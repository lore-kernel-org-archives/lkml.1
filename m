Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbXIKPQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbXIKPQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXIKPQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:16:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:16202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXIKPQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:16:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,238,1186383600"; 
   d="scan'208";a="302336871"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Tue, 11 Sep 2007 08:15:30 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03023D9E@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070911142014.GG1932@ld0162-tx32.am.freescale.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
thread-index: Acf0fuhDqXjPzs8cTLqrlF1wQImgjAABwE4w
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <BAE9DCEF64577A439B3A37F36F9B691C02FF08A1@orsmsx418.amr.corp.intel.com> <46B96294322F7D458F9648B60E15112C85D61E@zch01exm26.fsl.freescale.net> <20070911142014.GG1932@ld0162-tx32.am.freescale.net>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Scott Wood" <scottwood@freescale.com>,
       "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
Cc: <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Sep 2007 15:15:32.0496 (UTC) FILETIME=[98847100:01C7F486]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Scott Wood [mailto:scottwood@freescale.com] 
>Sent: Tuesday, September 11, 2007 7:20 AM
>To: Zhang Wei-r63237
>Cc: Nelson, Shannon; paulus@samba.org; 
>linuxppc-dev@ozlabs.org; Williams, Dan J; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale 
>MPC85xx processors.
>
>On Tue, Sep 11, 2007 at 06:10:53PM +0800, Zhang Wei-r63237 wrote:
>> > >+
>> > >+	fsl_dma_memcpy_issue_pending(chan);
>> > >+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
>> > >+			!= DMA_SUCCESS);
>> > 
>> > Again, is it possible to hang your thread here?
>> > 
>> > [...]
>> 
>> I'll add msleep here.
>
>I think what was being sought was a timout, causing the test to return
>failure.
>
>-Scott
>

Either a timeout to stop the polling, or msleep() followed by a single
call to fsl_dma_is_complete().  However, using the msleep() method is
likely to be kinder to the rest of the kernel than polling for very
long.

sln
