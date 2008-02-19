Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYBSSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYBSSzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYBSSzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:55:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:34665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYBSSzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:55:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,377,1199692800"; 
   d="scan'208";a="380993663"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC v3 4/7] dmaengine: Add slave DMA interface
Date: Tue, 19 Feb 2008 10:46:54 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C040CB607@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080218142949.2c5b2810@dhcp-252-066.norway.atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC v3 4/7] dmaengine: Add slave DMA interface
Thread-Index: AchyMocGe8DwhdQQTTCA6Lj6bM/kdwA9NV4g
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com><1202834638-9009-2-git-send-email-hskinnemoen@atmel.com><1202834638-9009-3-git-send-email-hskinnemoen@atmel.com><1202834638-9009-4-git-send-email-hskinnemoen@atmel.com><e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com><20080213202402.22818482@siona><20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com><BAE9DCEF64577A439B3A37F36F9B691C0407A37A@orsmsx418.amr.corp.intel.com> <20080218142949.2c5b2810@dhcp-252-066.norway.atmel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Feb 2008 18:46:54.0469 (UTC) FILETIME=[CC11B350:01C87327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Haavard Skinnemoen [mailto:hskinnemoen@atmel.com] 
>Sent: Monday, February 18, 2008 5:30 AM
>To: Nelson, Shannon
>Cc: Haavard Skinnemoen; Williams, Dan J; 
>linux-kernel@vger.kernel.org; David Brownell; 
>kernel@avr32linux.org; Francis Moreau; Paul Mundt; Vladimir A. 
>Barinov; Pierre Ossman
>Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
>
>On Fri, 15 Feb 2008 09:12:35 -0800
>"Nelson, Shannon" <shannon.nelson@intel.com> wrote:
>
>> I'll jump in here briefly - I'm okay with the direction this 
>is going,
>> but I want to be protective of ioatdma performance.  As used 
>in struct
>> ioat_desc_sw, the cookie and ack elements end up very close 
>to the end
>> of a cache line and I'd like them to not get pushed out across the
>> boundry.  I don't think this proposal changes the layout, I'm just
>> bringing up my concern.
>
>Sure, performance is very important, and it's good to see that you're
>critical about the changes I'm proposing. That said, the memory layout
>doesn't change at all with this patch -- the fields that didn't go into
>the generic dma descriptor were at the end of the struct to begin with.
>
>I can add a comment saying that cookie and ack must always come first.
>Any other fields that we need to be careful about?
>
>Haavard
>

Those are the only two that I'm worried about at the moment.  I'm just
hoping that a quirk in some compiler's struct packing doesn't push them
over that edge.

Thanks,
sln
