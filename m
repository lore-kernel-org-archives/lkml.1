Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYHKOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYHKOPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYHKOPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:15:08 -0400
Received: from il.qumranet.com ([212.179.150.194]:14876 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYHKOPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:15:06 -0400
Message-ID: <48A04968.7000805@qumranet.com>
Date: Mon, 11 Aug 2008 17:15:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>
Subject: Re: Use of barriers in pvclock ABI
References: <489CA3DA.1090400@goop.org> <489FE56E.1080707@redhat.com>
In-Reply-To: <489FE56E.1080707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>   Hi,
>
>   
>> However, the pvclock_clocksource_read() implementation is
>> over-engineered, because it checks for an odd version and uses very
>> strong rmb() barriers (which generates either an "lfence" or "lock add
>> $0, (%esp)").
>>
>> If we're happy to guarantee as an ABI issue that the record will never
>> be updated cross-cpu, then we can make the barriers simply barrier() and
>> just check for (src->version != dst->version).
>>
>> Is that OK with you, or do you want to leave open the possibility of
>> doing cross-cpu time updates?
>>     
>
> Due to the TSC being involved here I don't expect cross-cpu time updates
> will ever happen.  IMHO it is fine to change that.
>
>   

I agree.  And if we ever feel the need, we can allocate a feature bit 
for it.

-- 
error compiling committee.c: too many arguments to function

