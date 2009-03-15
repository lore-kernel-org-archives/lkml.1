Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZCOSjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZCOSjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCOSix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:38:53 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:50330 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZCOSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:38:52 -0400
Message-ID: <49BD4B2D.7000501@krogh.cc>
Date: Sun, 15 Mar 2009 19:38:37 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 15 Mar 2009, Jesper Krogh wrote:
>> Linus Torvalds wrote:
>>> Regardless of whether is succeeds or not, it will print out some debug
>>> messages, which will be interesting to see.
>>
>> [    0.000000] Fast TSC delta=34227730, error=6223+6219=12442
>> [    0.000000] Fast TSC calibration using PIT
>> [    0.000000] Detected 2312.045 MHz processor.
> 
> Ok. This claims that the error really is smaller than 500ppm (it's about 
> 360 ppm). Which is about what we're aiming for (in real life, the actual 
> error is about half that - we're just adding up the error terms for 
> maximum theoretical error).
> 
>> Using "ntpq -c peers" .. the offset steadily grows as time goes.
>>
>> Full dmesg: http://krogh.cc/~jesper/dmesg-linux-2.6.29-rc8-linus1.txt
>>
>> jk@quad11:~$ ntpdc -c kerninfo
>> pll offset:           0.085167 s
>> pll frequency:        -18.722 ppm
>> maximum error:        0.137231 s
>> estimated error:      0.008823 s
>> status:               0001  pll
>> pll time constant:    6
>> precision:            1e-06 s
>> frequency tolerance:  500 ppm
> 
> Hmm. But now it all seems to _work_, no? Or do you still get time resets? 

My conclusion was that I would get a time reset after some time since 
the offset just increased as time went by (being reasonably small at the
beginning).

I had it up for around 30 minutes... Should I have tested longer?

I went on to trying Thomas Gleixners patch (which seems to do excactly 
the same .. ), I'll write a reply in to that message in a few minutes.

-- 
Jesper
