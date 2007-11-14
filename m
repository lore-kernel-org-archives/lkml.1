Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbXKNPss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbXKNPss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXKNPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:48:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXKNPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:48:40 -0500
Message-ID: <473B17D4.5050702@redhat.com>
Date: Wed, 14 Nov 2007 10:44:20 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stephane Eranian <eranian@hpl.hp.com>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
References: <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com> <20071114142411.GD17145@one.firstfloor.org>
In-Reply-To: <20071114142411.GD17145@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>> One approach does not prevent the other. Assuming you allow cr4.pce, then nothing prevents
>> a self-monitoring thread from reading the counters directly. You'll just get the
>> lower 32-bit of it. So if you read frequently enough, you should not have a problem.
> 
> Hmm? RDPMC is 64bit.

There are a number of processors that have 32-bit counters such as the IBM power 
processors. On many x86 processors the upper bits of the counter are sign 
extended from the lower 32 bits. Thus, one can only assume the lower 32-bit are 
available. Roll over of values is quite possible (<2 seconds of cycle count), so 
additional work needs to be done to obtain a valid value.

>> But keep in mind that we do want a uniform interface across all hardware and all type
>> of sessions (self-monitoring, CPU-wide, monitoring of another thread). You don't want
>> an interface that says on x86 you have to use rdpmc, on Itanium pfm_read_pmds() and so
> 
> I disagree. Using RDPMC is essential for at least some of the things I would like
> to do with perfmon2. If the interface does not provide it it is useless to me at least.
> System calls are far too slow for cycle measurements. 

What range of cycles are you interested in measuring? 100's of cycles? A couple 
thousand? Are you just looking at cycle counts or other events?

-Will
