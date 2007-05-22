Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbXEVSAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbXEVSAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXEVSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:00:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:11419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXEVSAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,566,1170662400"; 
   d="scan'208";a="248491555"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Increased ipw2200 power usage with dynticks
Date: Tue, 22 May 2007 11:00:03 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5EA5415@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070522092359.GA13298@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Increased ipw2200 power usage with dynticks
Thread-Index: AcecUvCRA817kuq0SvWd85DeNKJF4QARtPzA
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: =?iso-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       "Brown, Len" <len.brown@intel.com>, <tglx@linutronix.de>,
       <mingo@elte.hu>, "Zhu, Yi" <yi.zhu@intel.com>,
       <linux-kernel@vger.kernel.org>, <arjan@infradead.org>, <trenn@suse.de>
X-OriginalArrivalTime: 22 May 2007 18:00:04.0161 (UTC) FILETIME=[0638FB10:01C79C9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Tuesday, May 22, 2007 2:24 AM
>To: Pallipadi, Venkatesh
>Cc: Björn Steinbrink; Andi Kleen; Brown, Len; 
>tglx@linutronix.de; mingo@elte.hu; Zhu, Yi; 
>linux-kernel@vger.kernel.org; arjan@infradead.org; trenn@suse.de
>Subject: Re: Increased ipw2200 power usage with dynticks
>
>> 
>> Nice to hear that cpuidle-menu governor gets 13.9W :-).
>> Powertop will need some changes to go with cpuidle, but that 
>should be simple.
>> 
>> We need some more testing for cpuidle before it gets into git.
>> Len: Looks like cpuidle got dropped out of mm again. Can you 
>merge it back it please.
>
>It probably needs some good review. I'm still not completely convinced
>its full generity is needed for example. e.g. how would 
>different governours
>look like?  Wouldn't it make more sense to concentrate on a single
>policy ?

Agreed. I don't think we really need to have multiple governors being changed at run time.

The current idea is that we will have multiple governors changeable at run time only for
DEBUG and DEVELOPMENT. On a standard end user system there will be one governor
(current optimal governor) that will be loaded. This gives
flexibality to experiments with governors and also easily have different governors for
different kind of platforms - in future if needed (handheld v/s laptop v/s server).
Also, there are no overheads at runtime due to the fact that we have underlying infrastructure
to have multiple governors (no locking overheads and such).

The above comment is where we want to go. But, this is not there in the code yet. We should
have that pretty soon though.

Yes. Comments are welcome (once it is back in acpi-test/mm) as always.

Thanks,
Venki
>
>-Andi
>
