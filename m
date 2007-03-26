Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXCZPzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXCZPzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXCZPzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:55:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:33736 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbXCZPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,330,1170662400"; 
   d="scan'208"; a="219473200:sNHT22025269"
Message-ID: <4607ECDE.3030803@intel.com>
Date: Mon, 26 Mar 2007 08:55:10 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: -rc5: e1000 resume weirdness
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>	 <20070326101153.GA4593@elte.hu> <4807377b0703260850g5b20df6eo5279760b5c10e946@mail.gmail.com>
In-Reply-To: <4807377b0703260850g5b20df6eo5279760b5c10e946@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2007 15:55:11.0503 (UTC) FILETIME=[22B459F0:01C76FBF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Brandeburg wrote:
> On 3/26/07, Ingo Molnar <mingo@elte.hu> wrote:
>> hm, on a T60, after suspend/resume, i get an e1000 timeout:
>>
>> e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>>   Tx Queue             <0>
>>   TDH                  <ec>
>>   TDT                  <ec>
>>   next_to_use          <ec>
>>   next_to_clean        <82>
>> buffer_info[next_to_clean]
>>   time_stamp           <fffcc3db>
>>   next_to_watch        <82>
>>   jiffies              <fffd5da0>
>>   next_to_watch.status <1>
>>
>> it works fine after that reset. The e1000 driver didnt do this before
>> after resume the network was always available immediately. So this
>> appears to be a relatively new regression (post-rc3 or so). high-res
>> timers was disabled.
> 
> was there a "NETDEV WATCHDOG" message that follows this?  If not it is
> a harmless debug print.  Note the time_stamp and jiffies difference,
> very large, consistent with a resume.  I think we need to disable the
> internal e1000 tx hang code that causes this debug print when we are
> suspending.  I'll work with auke to generate a short patch.

hmm, yeah, it appears that the patch I sent just a second ago isn't applicable 
in this case, since the irq handler is obviously enabled (the Link Up message 
proves that).

thanks to Jesse for being awake :)


Auke
