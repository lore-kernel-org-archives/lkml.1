Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZCOPow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZCOPow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZCOPom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:44:42 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:43833 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZCOPom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:44:42 -0400
Message-ID: <49BD225C.4070305@krogh.cc>
Date: Sun, 15 Mar 2009 16:44:28 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>  <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Jesper, here's a patch that actually tries to take teh TSC error really 
> into account, and which I suspect will result (on your machine) in failing 
> the fast PIT calibration. 
> 
> It also has a few extra printk's for debugging, and to see just what the 
> values are on your machine.
> 
> The idea behind the patch is to just keep track of how big the difference 
> was in TSC values between two successive reads of the PIT timer. We only 
> really care about the difference when the MSB turns around, and we only 
> really care about the two end points. The maximum error in TSC estimation 
> will simply be the sum of the differences at those points (d1 and d2).
> 
> We can then compare the maximum error with the actual TSC differences 
> between those points, and see if the max error is within 500 ppm. That 
> _should_ mean that it all works - assuming that the PIT itself is running 
> at the correct frequency, of course!
> 
> Regardless of whether is succeeds or not, it will print out some debug 
> messages, which will be interesting to see.


[    0.000000] Fast TSC delta=34227730, error=6223+6219=12442
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2312.045 MHz processor.

Using "ntpq -c peers" .. the offset steadily grows as time goes.

Full dmesg: http://krogh.cc/~jesper/dmesg-linux-2.6.29-rc8-linus1.txt

jk@quad11:~$ ntpdc -c kerninfo
pll offset:           0.085167 s
pll frequency:        -18.722 ppm
maximum error:        0.137231 s
estimated error:      0.008823 s
status:               0001  pll
pll time constant:    6
precision:            1e-06 s
frequency tolerance:  500 ppm



-- 
Jesper


