Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYFLULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYFLULn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYFLULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:11:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:31697 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbYFLULc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kXFQ6iFPxkYny7Zg4wSby/G5w06+oQlSb3vjvzuAhHkuEv0ERCWaKYDke2/XdjyF4p
         z06bUs1v0zE2AvbiEHg4DjSsyBCQIl5GSeP5+Xkv6mHX0NLkAY7NpY1j4B8kCnAjlYo2
         /O/QQ2uXMzvZ5asnAnYX79/HmJp/62N0F37p8=
Message-ID: <c4e36d110806121311n64890e17h67f49c32481fbb28@mail.gmail.com>
Date: Thu, 12 Jun 2008 22:11:32 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Tomas Winkler" <tomasw@gmail.com>, "Rik van Riel" <riel@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213294547.3730.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 <1213292812.3730.21.camel@johannes.berg>
	 <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com>
	 <1213294547.3730.29.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/12 Johannes Berg <johannes@sipsolutions.net>:
>
>> I'm not against it. You;v decided that I'm fighting you because I gave
>> another solution.
>
> Ok, no, I'm not saying you shouldn't rewrite all the code to get rid of
> it, but I think you can use a patch like mine interim as such a rewrite
> is unlikely to go into 2.6.26, is it?
>
>> Frankly we probably don't need this allocation at all. maybe one skb
>> is just enough
>
> That would be nice, indeed.
>
>> even with my never dying hope all fragments are in skb fragment list.
>
> :)
>
>> This still probably won't save pci memory allocation problem
>
> Yeah, true, that one needs to be done, but it could probably be done
> only once when hw is probed rather than every time it is brought up.
> Most likely not something you'll get to fix in 2.6.26 either though.


Well - it's great that there will be saved few kB in allocation of
never used pointers in iwl driver - but does this really solve the
problem that kernel gets relatively quickly out of memory for
allocations of this size - I guess iwl isn't the only driver
requesting 32 sequential pages.

Is it possible to track how this memory gets fragment/lost - who owns
the block and why they are not back in the pool?

btw with 8hour uptime at this moment I can see this:

DMA: 26*4kB 37*8kB 72*16kB 65*32kB 3*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 1*4096kB = 7920kB
DMA32: 203*4kB 79*8kB 26*16kB 11*32kB 6*64kB 9*128kB 3*256kB 2*512kB
2*1024kB 0*2048kB 0*4096kB = 7588kB

so at this moment I can see quiet a lot of free DMA memory - but in my
trace at the thread beginig after several suspend/resumes this memory
was gone....

Zdenek
