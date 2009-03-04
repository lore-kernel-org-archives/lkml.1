Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbZCDShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbZCDShV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZCDShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:37:07 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:47785 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbZCDShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:37:06 -0500
Message-ID: <49AECA3B.5030503@krogh.cc>
Date: Wed, 04 Mar 2009 19:36:43 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>	 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc> <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>
In-Reply-To: <49AE9EA4.2080500@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> john stultz wrote:
>> I guess something to test my idea above (that the drift is bad enough
>> that NTPd isn't making slew adjustments via adjtimex offset) is to
>> remove NTPd from the init.d startup.
>>
>> Then after rebooting (into 2.6.29), run the attached python script for
>> 10 minutes or so to get an idea of the ppm drift. Then repeat with
>> 2.6.26.
>>
>> To run: ./drift-test.py <ntp server>
>>
>> It will give some wild ppm numbers, but after a few minutes it should
>> settle down to the "natural drift" of the system.
> 
> Ok. I removed ntpd from the system... heres is from "non-working 

Updated. I think I has NTPd running in the former "non-working" test. I 
just tried to reproduce the numbers, and they look like this 
(reproducible on 2.6.29-rc6).

jk@quad12:~$ python drift-test.py 10.192.96.19
04 Mar 19:27:10         offset: -0.157696       drift: -693.0 ppm
04 Mar 19:28:10         offset: -0.195134       drift: -625.098360656 ppm
04 Mar 19:29:10         offset: -0.232579       drift: -624.595041322 ppm
04 Mar 19:30:10         offset: -0.270021       drift: -624.408839779 ppm
04 Mar 19:31:11         offset: -0.307461       drift: -621.727272727 ppm
04 Mar 19:32:11         offset: -0.344903       drift: -622.185430464 ppm
04 Mar 19:33:11         offset: -0.382345       drift: -622.491712707 ppm
04 Mar 19:34:11         offset: -0.419794       drift: -622.727488152 ppm
04 Mar 19:35:11         offset: -0.457239       drift: -622.89626556 ppm

Still the same.

> And from working 2.6.27.19 kernel.
> 
> jk@quad12:~$ python drift-test.py 10.192.96.19
> 04 Mar 16:17:23         offset: -0.006929       drift: -62.0 ppm
> 04 Mar 16:18:24         offset: -0.010252       drift: -54.5967741935 ppm
> 04 Mar 16:19:24         offset: -0.013574       drift: -54.9754098361 ppm
> 04 Mar 16:20:24         offset: -0.016897       drift: -55.1098901099 ppm
> 04 Mar 16:21:24         offset: -0.020233       drift: -55.2314049587 ppm
> 04 Mar 16:22:24         offset: -0.023566       drift: -55.2947019868 ppm
> 04 Mar 16:23:24         offset: -0.026895       drift: -55.3259668508 ppm
> 04 Mar 16:24:24         offset: -0.030217       drift: -55.3317535545 ppm
> 04 Mar 16:25:24         offset: -0.033539       drift: -55.3360995851 ppm
> 04 Mar 16:26:24         offset: -0.036865       drift: -55.3468634686 ppm
> 04 Mar 16:27:25         offset: -0.038266       drift: -52.0713101161 ppm
> 04 Mar 16:28:25         offset: -0.039747       drift: -49.592760181 ppm
> 04 Mar 16:29:25         offset: -0.041331       drift: -47.6680497925 ppm



-- 
Jesper
