Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXCHPJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXCHPJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbXCHPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:09:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:20405 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXCHPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:08:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=WE4WIxlHJV3AZp8vO0OC6olfXcyhASp7fDIMXdgmLCBDeLrmtwIF2ELkvKAzCR2GpJywJ3aFOy5IF8MQScmuf5DedhIHGowX1aauAmTwD4VaoGsDztjmQ1jw17YiRIb7blFrBwQ38AS4pmQ4r9ow5uHGP456ysrKFeCDYrjJ37s=
Message-ID: <45F02697.1070900@googlemail.com>
Date: Thu, 08 Mar 2007 16:07:03 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <hansendc@us.ibm.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.21-rc2-mm2 hang
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>	<1173305536.868.8.camel@localhost.localdomain>	<20070307221628.GD26473@linux-os.sc.intel.com>	<1173308841.868.14.camel@localhost.localdomain> <20070307151658.bfcd90e1.akpm@linux-foundation.org>
In-Reply-To: <20070307151658.bfcd90e1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Wed, 07 Mar 2007 15:07:21 -0800
> Dave Hansen <hansendc@us.ibm.com> wrote:
> 
>> On Wed, 2007-03-07 at 14:16 -0800, Siddha, Suresh B wrote:
>>> On Wed, Mar 07, 2007 at 02:12:16PM -0800, Dave Hansen wrote:
>>>> I'm seeing weird hangs running ltp on 2.6.21-rc2-mm2.  It manifests
>>>> itself by the waitpid06 test in LTP hanging.  This is very, very
>>>> reproducible in about 5 seconds by adding '-s wait' to the ltp command
>>>> line.
>>>>
>>>> I see 4 waitpid06 processes on my 4-way machine spinning in userspace.
>>>> But, the weird part is that I can't ssh in once this happens, but I can
>>>> log in to the console.  I've bisected it down to:
>>>>         
>>>>         sched-fix-idle-load-balancing-in-softirqd-context
>>> This sounds like an issue in merge we recently had and 2.6.21-rc2-mm2 already
>>> has a fix for this.
>>>
>>> sched-fix-idle-load-balancing-in-softirqd-context-fix.patch  
>>>
>>> Can you please apply both
>>> sched-fix-idle-load-balancing-in-softirqd-context
>>> sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
>>> and see if you still see this problem?
>> I was confused that I couldn't find this fix in my patches directory,
>> but I double-checked, and realized that I was still on 2.6.21-rc2-mm1.
>> I must have grabbed the wrong broken-out tarball when I started the
>> bisect.  Darn.
>>
>> Anyway, 2.6.21-rc2-mm2 appears to be OK.  Sorry for the false alarm.
>>
> 
> Ah, OK.  I'll undrop those three patches.
> 
> Michal, did rc2-mm2 make that weird hang go away for you?
> 

No, it works fine for me since -rc2-mm2.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
