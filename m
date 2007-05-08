Return-Path: <linux-kernel-owner+w=401wt.eu-S934847AbXEHK1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbXEHK1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934736AbXEHK1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:27:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:61051 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934701AbXEHK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=TLcvlP+pziNxlljnxawkG6GoPXIhctn2eIieiEqVAYrmQ3zlhqGbx7fybCn1J3VCpzLjxTYGu4usvXnk1PVYXqJG9OecgvK7uEFdg+foRx8tE1J9DV2EJpKxvL1LVH2e/u1xuGnHQk8IvBihPTXSZySlHzVjDXc4TUbhhkhg2SU=
Date: Tue, 8 May 2007 12:27:28 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Johannes Stezenbach <js@linuxtv.org>
cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070508095421.GA10456@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0705081220540.17437@frodo.shire>
References: <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu>
 <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu>
 <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
 <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
 <20070507183931.GB3472@linuxtv.org> <Pine.LNX.4.64.0705080931460.10409@frodo.shire>
 <20070508095421.GA10456@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Johannes Stezenbach wrote:

> On Tue, May 08, 2007, Esben Nielsen wrote:
>>
>> This is contrary to C99 standeard annex H2.2
>> (http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf):
>>
>> "An implementation that defines signed integer types as also being modulo
>> need
>> not detect integer overflow, in which case, only integer divide-by-zero need
>> be detected."
>>
>> So if it doesn't properly defines wrapping it has to detect integer
>> overflow, right?
>
> No. Annex H (informative!) only talks about LIA-1 conformance.
>
> C99 isn't LIA-1 conformant. H2.2 describes what an implementation
> might do to make signed integers LIA-1 compatible.

"The signed C integer types int, long int, long long int, and the 
corresponding unsigned types are compatible with LIA-1."

I read this as any C99 implementation must be compatible. I would like to 
see LIA-1 to check.


>, which is
> what gcc does with -fwarpv or -ftrapv.
>

Yes, either or: Either wrap or trap.

> At least that's how I understand it, the C99 standard
> seems to have been written with the "it was hard to
> write, so it should be hard to read" mindset. :-/
>
> I still don't know _why_ signed integer overflow behaviour
> isn't defined in C. It just goes against everyones expectation
> and thus causes bugs.

Because it is hard to make wrapping work on non twos complement 
architectures. Then it is easier to trap.

Esben

>
>
> Johannes
>
