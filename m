Return-Path: <linux-kernel-owner+w=401wt.eu-S934158AbXHFXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158AbXHFXkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933121AbXHFXkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:40:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:39942 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932953AbXHFXkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:40:07 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18dNCksrbEdJMNK/elE9mALWygh85kO1v3EshcNtb
	kdWMUJ4bvjN7M6
Message-ID: <46B7BF67.8010506@gmx.net>
Date: Tue, 07 Aug 2007 02:40:07 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net>	<200708051903.12414.jimis@gmx.net>	<46B60FB7.8030301@interia.pl>	<200708052142.14630.jimis@gmx.net>	<46B748DE.1060108@interia.pl>	<46B773F6.7060603@gmx.net> <20070806204853.6a693c4b@the-village.bc.nu>
In-Reply-To: <20070806204853.6a693c4b@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
>>> In Your oprofile output I find "acpi_pm_read" particulary interesting. 
>>> Unlike other VIA chipsets, which I know, Your doesn't use VLink to 
>>> connect northbridge to southbridge. Instead PCI bus connects these two. 
>>> As You probably know maximal PCI throughtput is 133MiB/s. In theory. In 
>>> practice probably less.
> 
> acpi_pm_read is capable of disappearing into  SMM traps which will make
> it look very slow.

what is an SMM trap? I googled a bit but didn't get it...

> 
>> about 15MB/s for both disks. When reading I get about 30MB/s again from 
>> both disks. The other disk, the small one, is mostly idle, except for 
>> writing little bits and bytes now and then. Since the problem occurs 
>> when writing, 15MB/s is just too little I think for the PCI bus.
> 
> Its about right for some of the older VIA chipsets but if you are seeing
> speed loss then we need to know precisely which kernels the speed dropped
> at. Could be there is an I/O scheduling issue your system shows up or
> some kind of PCI bus contention when both disks are active at once.

I am sure throughput kept diminishing little by little with many 2.6 
releases, and that it wasn't a major regression on a specific version. 
Unfortunately I cannot backup my words with measurements from older 
kernels right now, since the system is hard to boot with such (new udev, 
new glibc). However I promise I'll test in the future (probably using 
old liveCDs) and come back then with proof.

> 
>> I have been ignoring these performance regressions because of no 
>> stability problems until now. So could it be that I'm reaching the 
>> 20MB/s driver limit and some requests take too long to be served?
> 
> Nope.

the reason I'm talking about a "software driver limit" is because I am 
sure about some facts:
- The disks can reach very high speeds (60 MB/s on other systems with udma5)
- The chipset on this specific motherboard can reach much higher 
numbers, as was measured with old kernels.
- No cable problems (have been changed), no strange dmesg output.

So what is left? Probably only the corresponding kernel module.


Thanks,
Dimitris

