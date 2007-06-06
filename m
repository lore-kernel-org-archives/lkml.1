Return-Path: <linux-kernel-owner+w=401wt.eu-S935211AbXFFUR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935211AbXFFUR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765149AbXFFURs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:17:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:44613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764897AbXFFURr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="254009208"
Message-ID: <46671668.4090805@intel.com>
Date: Wed, 06 Jun 2007 13:17:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: generic bool and sparse errors?
References: <4666FD0A.4060609@intel.com> <466708D8.90208@student.ltu.se>
In-Reply-To: <466708D8.90208@student.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 20:17:45.0958 (UTC) FILETIME=[BED56860:01C7A877]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson wrote:
> Kok, Auke wrote:
>> I'm experimenting with using the generic bool type and using sparse I 
>> get tons of these messages:
>>
>> warning: incorrect type in argument 4 (different signedness)
>>     expected bool [unsigned] [usertype] *[unsigned] success
>>     got bool *<noident>
>>
>> I'm not really worried about this, I assume that sparse hasn't caught 
>> up with what bool really means, but perhaps this can be looked into by 
>> someone who knows sparse well. The warnings don't really add up and 
>> with more people switching to use the generic bool this may beceome 
>> unwanted.
 >
> Actually, I am "assigned" to that. :)

ah cool

> Just out of curiousity, where do you see those messages? In the log for 
> allyesconfig on i386 I only found ntfs/super.c with similar output.

I was poking around replacing the boolean_t typedef in e1000, so it's nothing 
upstream. Just run `sed -i s/boolean_t/bool/g` on all the files in 
drivers/net/e1000 to see :)

the version of sparse is that in fc6, so that may be out-of-date (?).

>> alternatively we might need to reconsider the `typedef _Bool bool;` 
>> declaration and force it to be unsigned. I'm not sure what to think of 
>> that.
> I do not see how that would make any sense.

well the sparse warning is about signedness. Either sparse needs to "know" that 
bool is unsigned, or the kernel headers need to somehow make bool unsigned... 
the latter choice would come down to just that, but it doesn't look like a good 
idea to me either somehow.

Auke
