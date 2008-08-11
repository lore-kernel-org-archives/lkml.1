Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYHKOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYHKOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYHKOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:35:31 -0400
Received: from il.qumranet.com ([212.179.150.194]:18423 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYHKOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:35:30 -0400
Message-ID: <48A04E30.9050105@qumranet.com>
Date: Mon, 11 Aug 2008 17:35:28 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>
Subject: Re: Use of barriers in pvclock ABI
References: <489CA3DA.1090400@goop.org> <489FE56E.1080707@redhat.com> <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
In-Reply-To: <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> On Mon, Aug 11, 2008 at 4:08 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>   
>>  Hi,
>>
>>     
>>> However, the pvclock_clocksource_read() implementation is
>>> over-engineered, because it checks for an odd version and uses very
>>> strong rmb() barriers (which generates either an "lfence" or "lock add
>>> $0, (%esp)").
>>>
>>> If we're happy to guarantee as an ABI issue that the record will never
>>> be updated cross-cpu, then we can make the barriers simply barrier() and
>>> just check for (src->version != dst->version).
>>>
>>> Is that OK with you, or do you want to leave open the possibility of
>>> doing cross-cpu time updates?
>>>       
>> Due to the TSC being involved here I don't expect cross-cpu time updates
>> will ever happen.  IMHO it is fine to change that.
>>     
>
> Okay for guest vcpu, but what about physical cpus?
>
>   
> IIRC, the checks are there, and so strict, to account for the
> possiblity of the vcpu to be migrated to another cpu in the middle of
> the
>   


Migration implies an smp barrier (but not a compiler barrier, of 
course).  As to the the version number oddness check, I don't see how it 
can be necessary.


-- 
error compiling committee.c: too many arguments to function

