Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYGRPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYGRPxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYGRPxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:53:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:58697 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYGRPxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,211,1215414000"; 
   d="scan'208";a="598983935"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma driver
Date: Fri, 18 Jul 2008 16:53:03 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101D2C62A@swsmsx413.ger.corp.intel.com>
In-Reply-To: <e9c3a7c20807111307q1b7c4ed0wb2864e2dae6abe90@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma driver
thread-index: AcjjkcBnWkyuYWPXTaqNOApJAPQbwQFWwdHA
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2008 15:53:04.0805 (UTC) FILETIME=[5D77C550:01C8E8EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Fri, Jul 11, 2008 at 4:36 AM, Maciej Sosnowski
> <maciej.sosnowski@intel.com> wrote:
>> Due to occasional DMA channel hangs observed for I/OAT versions 1.2
>> and 2.0 a watchdog has been introduced to check every 2 seconds
>> if all channels progress normally.
>> If stuck channel is detected, driver resets it.
>> The reset is done in two parts. The second part is scheduled
>> by the first one to reinitialize the channel after the restart.
>> 
> 
> checkpatch had some valid suggestions, please give it a run.

Hi Dan,
Thanks a lot for your review.
I have just sent v2 of this patch series updated according to your
suggestions.
This includes resolving checkpatch issues.

> A general comment about this change it seems to add a bit of
> complexity.  The driver now has two workqueue routines and a tasklet.
> Might some of these be combined?  In other words, do we need a free
> running watchdog when no descriptors are in flight?  It seems that
> using a timer to kick the cleanup tasklet could be used in place of
> the ioat_dma_chan_watchdog workqueue.
 
The idea was to run watchdog not too frequently 
in order to minimize its impact on the performance.
That's why it is called every 2 secs.
Cleanup is a differnt story and it is called more frequently,
so it would be difficult to combine these two things.
BTW - cleanup tasklet is not used at the moment
(TCP does not use interrupts but polling for cleanups).

>> Sleep time in self_test has been increased to 10ms
>> since in some cases 1ms appeared not to be enough.
> 
> This should be broken out into a separate patch.  Perhaps with an
> explanation of why it needs extra time for this particular
> transaction.

It has been separated in v2.

> 
> Regards,
> Dan

Thanks,
Maciej
