Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZJ1Rrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZJ1Rrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZJ1Rrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:47:36 -0400
Received: from claw.goop.org ([74.207.240.146]:40593 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZJ1Rrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:47:36 -0400
Message-ID: <4AE883B9.4050409@goop.org>
Date: Wed, 28 Oct 2009 10:47:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
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
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default> <4AE739DA.20601@goop.org> <4AE7DC04.7080706@redhat.com> <20091028092900.GG3627@mothafucka.localdomain> <4AE81011.4040904@redhat.com>
In-Reply-To: <4AE81011.4040904@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/09 02:34, Avi Kivity wrote:
> On 10/28/2009 11:29 AM, Glauber Costa wrote:
>>> How can you reliably measure performance in a virtualized environment?
>>>      
>> If we loop gettimeofday(), I would expect the vsyscall-based version
>> not to show
>> up in strace, right?
>>    
>
> Much better to have an API for this.  Life is hacky enough already.

My point is that if an app cares about property X then it should just
measure property X.  The fact that gettimeofday is a vsyscall is just an
implementation detail that apps don't really care about.  What they care
about is whether gettimeofday is fast or not.

If the environment has such unstable timing that the effect can't be
measured, then it is moot whether its a vsyscall or not (but in that
case its almost certainly better to use the standard API rather than
trying to roll your own timesource with rdtsc).

    J
