Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYGBPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYGBPOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGBPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:14:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52194 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYGBPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:14:05 -0400
Message-ID: <486B9B3A.4060709@firstfloor.org>
Date: Wed, 02 Jul 2008 17:14:02 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <20080702003755.4daff613.akpm@linux-foundation.org> <87r6acsfo1.fsf@basil.nowhere.org> <20080702143554.GY9594@localdomain>
In-Reply-To: <20080702143554.GY9594@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Andi Kleen wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>> sysfs is part of the kernel ABI.  We should design our interfaces there
>>> as carefully as we design any others.
>> The basic problem is that sysfs exports an internal kernel object model
>> and these tend to change. To really make it stable would require 
>> splitting it into internal and presented interface.
> 
> True, but... /sys/devices/system/cpu has been there since around 2.6.5
> iirc.  A google code search for that path shows plenty of programs
> (including hal) that hard-code it.  Exposed object model or not,
> changing that path would break lots of software.

Yes it would.

But Greg is making noises of getting rid of sysdevs and it wouldn't
surprise me if that ended up being user visible since most object
model changes end up being visible.

> 
> 
>> I would be all
>> for it, but it doesn't seem realistic to me currently. If we cannot
>> even get basic interfaces like the syscall capability stable how would
>> you expect to stabilize the complete kobjects? 
>>
>> And the specific problem with the x86 cache sysfs interface is that it's so
>> complicated that no human can really read it directly. This means to
>> actually use it you need some kind of frontend (i have a cheesy
>> lscache script for this).
> 
> Human readability is nice, 

When it's not human readable, then it's usually also not Joe Normal Programmer
usable.

> but a more important issue IMO is whether
> the cache interface can be considered stable enough for programs to
> rely on it.  I notice there's no entry for it in Documentation/ABI.

For x86 it follows closely the Intel CPUID  architectural specification, which
can be considered stable (at least for Intel, other vendors do not
necessarily implement it. But for AMD it is faked at least)

-Andi

