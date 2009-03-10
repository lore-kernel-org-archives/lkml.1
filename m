Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZCJTnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZCJTnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZCJTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:42:58 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:36143 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZCJTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:42:57 -0400
Message-ID: <49B6C2B8.7000407@krogh.cc>
Date: Tue, 10 Mar 2009 20:42:48 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain> <alpine.LFD.2.00.0903101103510.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903101103510.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 9 Mar 2009, Linus Torvalds wrote:
>> On Mon, 9 Mar 2009, Jesper Krogh wrote:
>>> First boot.
>>> [    0.000000] ref_freq: 2311825  pit_freq: 2310386
>>> Second boot:
>>> [    0.000000] ref_freq: 2311803  pit_freq: 2310190
>>> Third boot:
>>> [    0.000000] ref_freq: 2311824  pit_freq: 2310080
>>> Fourth boot:
>>> [    0.000000] ref_freq: 2311831  pit_freq: 2310130
>> It's really quite impressively stable, but the fast-PIT calibration 
>> frequency is reliably about 3/4 of a promille low. Or, put another way, 
>> the TSC difference over the pit calibration is just a _tad_ too small 
>> compared to the value we'd expect if that loop of pit_expect_msb() would 
>> really run at the expected delay of a 1.193182MHz clock divided by 256.
>>
>> And it's stable in that it really always seems to be off by a very similar 
>> amount. It's not moving around very much.
>>
>> I also wonder why it seems to happen mainly just to _you_. There's 
>> absolutely nothing odd in your system, neither a slow CPU or anything 
>> else that would stand out.
>>
>> Grr. Very annoyingly non-obvious.
> 
> Indeed. One hint is in the slow calibration path. 3 of 4 boots have:
> 
>>> [    0.000000] TSC: PIT calibration matches PMTIMER. 2 loops
> 
> So the slow calibration path detects some disturbance.
> 
> Jesper, can you please apply the following patch instead of Johns and
> provide the output for a couple of boots? The output is:
> 
> Fast TSC calibration using PIT
> tsc 43425305 tscmin 624008 tscmax 632610

First boot:
[    0.000000] Fast TSC calibration using PIT
[    0.000000] tsc 34202223 tscmin 474069 tscmax 500664
Second boot:
Here I didnt get above messages.. http://krogh.cc/~jesper/dmesg-boot2.txt
Third boot:
[    0.000000] Fast TSC calibration using PIT
[    0.000000] tsc 34199856 tscmin 470321 tscmax 502182
Forth boot:
[    0.000000] Fast TSC calibration using PIT
[    0.000000] tsc 34202008 tscmin 475510 tscmax 501501

The second one is really strange.. is'nt it?

While booting up I saw this one on the serial console..
root@quad12:~# hwclock --systohc
Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access 
method.
root@quad12:~# hwclock --systohc --debug
hwclock from util-linux-ng 2.13.1
hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
No usable clock interface found.
Cannot access the Hardware Clock via any known method.

Jesper
-- 
Jesper

