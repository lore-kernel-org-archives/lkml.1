Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbXJKPeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbXJKPeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXJKPdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:33:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:24652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXJKPdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:33:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,260,1188802800"; 
   d="scan'208";a="169898132"
Message-ID: <470E424D.5080507@intel.com>
Date: Thu, 11 Oct 2007 08:33:33 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com> <20071009182857.GF4003@csclub.uwaterloo.ca> <470BCB4D.8090307@intel.com> <20071010204422.GC5097@linux.intel.com>
In-Reply-To: <20071010204422.GC5097@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2007 15:33:51.0450 (UTC) FILETIME=[1FF003A0:01C80C1C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Gross wrote:
> On Tue, Oct 09, 2007 at 11:41:17AM -0700, Kok, Auke wrote:
>> Lennart Sorensen wrote:
>>> On Mon, Oct 08, 2007 at 03:31:51PM -0700, Kok, Auke wrote:
>>>> you most certainly want to do this in userspace I think.
>>>>
>>>> One of the biggest problems is that link negotiation can take a significant amount
>>>> of time, well over several seconds (1 to 3 seconds typical) with gigabit, and
>>>> having your ethernet connection go offline for 3 seconds may not be the desired
>>>> effect for when you want to get more bandwidth in the first place.
>>>>
>>>> However, when a laptop is in battery mode, switching down from gigabit to 100mbit
>>>> makes a lot more sense, so this is something I would recommend. This can be as
>>>> easy as changing the advertisement mask of the interface and renegotiating the
>>>> link. Userspace could handle that very easily.
>>> Now if you were trying to transfer a lot of data to the laptop, would it
>>> be more power efficient to do it at gigabit speeds so you can finish
>>> sooner and shut down the machine entirely, or to slow to 100mbit and
>>> take longer to do it, and hence spend more time powering the cpu and
>>> ram?
>> my suspicion is that the cost of switching is much higher than what you would
>> consume running at 100mbit, even if the amount of data is quite large. going
>> offline to renegotiate the link would already cost you 3W typically.
>>
>> I definately think that userspace is the right field to solve this problem: let
>> the users decide how to use the available power on their sytems through a decent
>> power profile tool (perhaps gnome-power-manager or something like that). This way
>> the user can choose.
>>
> 
> Auke, 
> I was wondering if we could use PM-QOS to have the driver drop to the
> 100Mb speed, when requests for bandwidth and latency are not in effect?

sure, that would probably work just fine. Technically this is not that hard anyway

I suppose that HAL integration is lacking a bit and missing ethtool ioctl code for
this which would be another solution - and would work without any driver changes.

Auke
