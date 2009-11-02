Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbZKBT6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbZKBT6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZKBT6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:58:50 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36119 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbZKBT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=KaNia+PEgpQ7RGFY2PwmWht0TkrgB2NHOfQtpd7PIZcrEGi6KjZ3FTAGQNAVU71rhN
         J7YYe2KMWV52MyM9/ZU0nFaiVE7Q0VdTT168JKvwERq8C7cDRQE4G5/bMA3qMDFXUuT3
         5TXcasEbCVzwMAZR99cdwuGCARedLCN254NI8=
Message-ID: <4AEF39FA.9070707@gmail.com>
Date: Mon, 02 Nov 2009 20:58:50 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com> <4AE97861.1070902@gmail.com> <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com> <4AEAF145.3010801@gmail.com> <alpine.DEB.2.00.0910301218410.31986@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910301218410.31986@chino.kir.corp.google.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

> On Fri, 30 Oct 2009, Vedran Furac wrote:
> 
>>> The problem you identified in http://pastebin.com/f3f9674a0, however, is a 
>>> forkbomb issue where the badness score should never have been so high for 
>>> kdeinit4 compared to "test".  That's directly proportional to adding the 
>>> scores of all disjoint child total_vm values into the badness score for 
>>> the parent and then killing the children instead.
>> Could you explain me why ntpd invoked oom killer? Its parent is init. Or
>> syslog-ng?
>>
> 
> Because it attempted an order-0 GFP_USER allocation and direct reclaim 
> could not free any pages.
> 
> The task that invoked the oom killer is simply the unlucky task that tried 
> an allocation that couldn't be satisified through direct reclaim.  It's 
> usually unrelated to the task chosen for kill unless 
> /proc/sys/vm/oom_kill_allocating_task is enabled (which SGI requested to 
> avoid excessively long tasklist scans).

Oh, well, I didn't know that. Maybe rephrasing of that part of the
output would help eliminating future misinterpretation.

>> OK then, if you have a solution, I would be glad to test your patch. I
>> won't care much if you don't change total_vm as a baseline. Just make
>> random killing history.
> 
> The only randomness is in selecting a task that has a different mm from 
> the parent in the order of its child list.  Yes, that can be addressed by 
> doing a smarter iteration through the children before killing one of them.
> 
> Keep in mind that a heuristic as simple as this:
> 
>  - kill the task that was started most recently by the same uid, or
> 
>  - kill the task that was started most recently on the system if a root
>    task calls the oom killer,
> 
> would have yielded perfect results for your testcase but isn't necessarily 
> something that we'd ever want to see.

Of course, I want algorithm that works well in all possible situations.

Regards,

Vedran

