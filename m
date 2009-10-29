Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbZJ2MOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbZJ2MOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZJ2MOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZJ2MOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:14:18 -0400
Message-ID: <4AE986FE.3040104@redhat.com>
Date: Thu, 29 Oct 2009 14:13:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber Costa <glommer@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default> <4AE739DA.20601@goop.org> <4AE7DC04.7080706@redhat.com> <20091028092900.GG3627@mothafucka.localdomain> <4AE81011.4040904@redhat.com> <4AE883B9.4050409@goop.org>
In-Reply-To: <4AE883B9.4050409@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2009 07:47 PM, Jeremy Fitzhardinge wrote:
>> Much better to have an API for this.  Life is hacky enough already.
>>      
> My point is that if an app cares about property X then it should just
> measure property X.  The fact that gettimeofday is a vsyscall is just an
> implementation detail that apps don't really care about.  What they care
> about is whether gettimeofday is fast or not.
>    

But we can not make a reliable measurement.

> If the environment has such unstable timing that the effect can't be
> measured, then it is moot whether its a vsyscall or not (but in that
> case its almost certainly better to use the standard API rather than
> trying to roll your own timesource with rdtsc).
>    

If you're interested in gettimeofday() for a global monotonic counter 
you can fall back to atomic_fetch_and_add() which will be faster than a 
syscall even on large systems.  Maybe we should provide a vsyscall for 
global monotonic counters and implement it using a atomics or tsc 
instead of these hacks (I'm assuming here that the gettimeofday() calls 
are used to implement an atomic counter - are they?)

-- 
error compiling committee.c: too many arguments to function

