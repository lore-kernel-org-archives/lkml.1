Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYFBKxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYFBKxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYFBKxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:53:10 -0400
Received: from gw.goop.org ([64.81.55.164]:36821 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFBKxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:53:09 -0400
Message-ID: <4843D0EE.6070805@goop.org>
Date: Mon, 02 Jun 2008 11:52:30 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10 of 12] xen: implement save/restore
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080602092144.GA22955%yamahata@valinux.co.jp> <4843C578.6060201@goop.org> <20080602104701.GB22955%yamahata@valinux.co.jp>
In-Reply-To: <20080602104701.GB22955%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> On Mon, Jun 02, 2008 at 11:03:36AM +0100, Jeremy Fitzhardinge wrote:
>   
>> Isaku Yamahata wrote:
>>     
>>> What is the purpose of load_cr3() here?
>>> I'd like to make this load_cr3() more arch generic for ia64 support.
>>> (or eliminate it if possible)
>>>  
>>>       
>> I think it's an unnecessary left-over from when I was trying to get that 
>> stuff to work.  I can't think of a good reason not to just remove it if 
>> it causes you problems.
>>     
>
> Here is the patch. I did only compile test.
>
>
>   
>> BTW, I tried to split the suspend/resume stuff into common and things 
>> which were definitely x86-specific with you in mind.  How close did I get?
>>     
>
> Almost complete. Your effort made my task easier.
> I haven't yet succeeded to save/restore, though.
>
> Is CONFIG_PM_SLEEP necessary?
>   
Yes.

It's necessary because the Xen save/restore code calls into various core 
functions to handle things like resuming timekeeping; that code is 
compiled controlled by CONFIG_PM_SLEEP.

> Since ia64 doesn't define ARCH_HIBERNATION_POSSIBLE nor
> ARCH_SUSPEND_POSSIBLE.
> Although I can define them in ia64/xen/Kconfig, I'd like to leave
> them untouched if possible.
>   

Hm, not sure how can address that then.

I'll confirm test that the load_cr3() is unnecessary later today.

    J
