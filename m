Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbYLHHnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbYLHHnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYLHHmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:42:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35383 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYLHHms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:42:48 -0500
Message-ID: <493CCFE4.2080802@jp.fujitsu.com>
Date: Mon, 08 Dec 2008 16:42:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AE770.5030507@shaw.ca>	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org> <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
In-Reply-To: <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> I noticed something else, which though may be due to my inexperience
> with mce messages. In my directory /sys/devices/system/machinecheck
> there are machinecheck0-7(one for each logical cpu of my system I
> presume). Having received the MCE log always for cpu 0, I went to look
> inside dir machinecheck0 and I found bank0-5ctl. So now my question
> is, why do I receive MCE logs about bank 6, if my cpus don't have a
> bank 6? Does that count start from 1? Or am I missing something else?

Answer would be in the following commit:

> commit 8edc5cc5ec880c96de8e6686fb0d7a5231e91c05
> Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Mon May 12 15:43:34 2008 +0200
> 
>     x86: remove 6 bank limitation in 64 bit MCE reporting code
(snip)
>     The patch below does not create sysfs control (bankNctl) for banks
>     higher than 6 as well. That needs some pre-cleanup in /sysfs mce layout,
>     removal of per cpu /sysfs entries for bankctl as they are really global
>     system level control today. That change will follow. This basic change
>     is critical to report the detailed errors on banks higher than 6.

So there are 6 sysfs control(bank0-5ctl) even if your cpu have more banks.

Old kernel with bank limitation will say:
"MCE: warning: using only %d banks\n"
And it seems that old kernel will ignore records in banks higher than 6.

Thanks,
H.Seto

