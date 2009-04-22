Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZDVRFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZDVRFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZDVREy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:04:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55439 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZDVREx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:04:53 -0400
Message-ID: <49EF4E14.6090708@ti.com>
Date: Wed, 22 Apr 2009 12:04:20 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com> <1240358715.6080.42.camel@localhost> <49EE89EF.1000707@ti.com> <49EF37FC.8020909@nortel.com>
In-Reply-To: <49EF37FC.8020909@nortel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Friesen wrote:
> Isn't "long long" guaranteed to be 64-bit on all linux systems?

If long long is guaranteed to be 64-bits this is the way to go. Looks 
like there was some previous discussion on making u64 always a long 
long, but I am not sure that this happened [1]. So may be this does 
confirm this?

> Unless the width is critical, I'd prefer to stay away from u64 until it 
> gets unified between architectures.  I recently ran into a problem 
> printk-ing a "u64" value because it was a different type on ppc64 than 
> x86-64.

It is not critical but maybe more ideal, as it would be nice to be 
explicit that this variable is intended to be 64bits. In fact the issue 
you saw with the printk is one of the reasons that I previously 
mentioned of why I had opted to stay with long long. I also found that 
this issue was discussed in the thread I mentioned above [1]. Seems like 
a common problem.

The alternative is to use u64 and make sure that all printks cast the 
variable to long long where necessary. However, this is not clean and 
you do run the risk of a new print being added that does not take this 
into account and breaks the code for some architectures. So I wished to 
avoid this.

For this specific case using long long should be fine. Even if there is 
a case where long long is not 64bits, then this would not break 
functionality, simply increase of decrease the dynamic range of 
max_delta_ns and min_delta_ns.

Cheers
Jon

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0807.2/2805.html


