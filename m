Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbYCEWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbYCEWAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763708AbYCEWAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:00:31 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:60532 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763481AbYCEWAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:00:30 -0500
Message-ID: <47CF17F7.4030405@nortel.com>
Date: Wed, 05 Mar 2008 16:00:23 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Todd Tomaino <ttomaino@rivulet.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: E1000:   e1000_update_stats()
References: <67F3071335CB9945A6047FE06957E0240D6D94CE93@exchange.rivulet.com> <47CF0F1F.1080402@nortel.com> <47CF136A.8070202@intel.com>
In-Reply-To: <47CF136A.8070202@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 22:00:25.0804 (UTC) FILETIME=[512910C0:01C87F0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> the update_stats function is only called every two seconds, and scheduled once. I
> think that the chance that two of these functions run in contention in the way you
> point out are practically zero, and if they do then we have much bigger problems
> than just counters being wrong...

I recently did an investigation that ended up sampling a subset of those 
stats every millisecond (to get an accurate picture of how many packets 
were being arriving vs being dropped due to rx_fifo errors over short 
intervals).  Ultimately it turned out that we had very bursty traffic. 
So it's not entirely unheard-of to sample at much higher rates.

At the very least, if we're going to remove the atomicity of reading 
registers and updating stats, how about adding a comment to this effect 
in the code?

Chris
