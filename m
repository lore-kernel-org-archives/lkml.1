Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXJISlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXJISlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXJISle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:41:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:7309 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbXJISld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="295494183"
Message-ID: <470BCB4D.8090307@intel.com>
Date: Tue, 09 Oct 2007 11:41:17 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com> <20071009182857.GF4003@csclub.uwaterloo.ca>
In-Reply-To: <20071009182857.GF4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2007 18:41:31.0811 (UTC) FILETIME=[02CF3F30:01C80AA4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Mon, Oct 08, 2007 at 03:31:51PM -0700, Kok, Auke wrote:
>> you most certainly want to do this in userspace I think.
>>
>> One of the biggest problems is that link negotiation can take a significant amount
>> of time, well over several seconds (1 to 3 seconds typical) with gigabit, and
>> having your ethernet connection go offline for 3 seconds may not be the desired
>> effect for when you want to get more bandwidth in the first place.
>>
>> However, when a laptop is in battery mode, switching down from gigabit to 100mbit
>> makes a lot more sense, so this is something I would recommend. This can be as
>> easy as changing the advertisement mask of the interface and renegotiating the
>> link. Userspace could handle that very easily.
> 
> Now if you were trying to transfer a lot of data to the laptop, would it
> be more power efficient to do it at gigabit speeds so you can finish
> sooner and shut down the machine entirely, or to slow to 100mbit and
> take longer to do it, and hence spend more time powering the cpu and
> ram?

my suspicion is that the cost of switching is much higher than what you would
consume running at 100mbit, even if the amount of data is quite large. going
offline to renegotiate the link would already cost you 3W typically.

I definately think that userspace is the right field to solve this problem: let
the users decide how to use the available power on their sytems through a decent
power profile tool (perhaps gnome-power-manager or something like that). This way
the user can choose.

Auke
