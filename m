Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbZKDVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbZKDVTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbZKDVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:19:35 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:39587 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbZKDVTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eKSqYkrHH6H7Bk5xtkhjFdR4+WqGYGb3Vu2MhnOSoogZefwwMCQETtKX+JtC7DY+lF
         zPTFU9JL2dHfOJsl1OIOvBsG19OscrvnaK5Qbl4g++h/obO1shIbvKGbccL3gCSXSGAY
         OMZmKi2EbW9JhDFS6d5L9QKsd7nELtI155KSw=
MIME-Version: 1.0
In-Reply-To: <4AE9AFAE.5020306@redhat.com>
References: <6137c066-3dfd-49dd-bbf2-7718f8542958@default>
	 <4AE9AFAE.5020306@redhat.com>
Date: Wed, 4 Nov 2009 13:19:39 -0800
X-Google-Sender-Auth: 1c2166c8080918c5
Message-ID: <1f1b08da0911041319l3687fb58te0a3e1debf185d6c@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall 
	implementation
From: john stultz <johnstul@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 7:07 AM, Avi Kivity <avi@redhat.com> wrote:
> On 10/29/2009 04:46 PM, Dan Magenheimer wrote:
>>
>> No, the apps I'm familiar with (a DB and a JVM) need a timestamp
>> not a monotonic counter.  The timestamps must be relatively
>> accurate (e.g. we've been talking about gettimeofday generically,
>> but these apps would use clock_gettime for nsec resolution),
>> monotonically increasing, and work properly across a VM
>> migration.  The timestamps are taken up to a 100K/sec or
>> more so the apps need to ensure they are using the fastest
>> mechanism available that meets those requirements.
>>
>
> Out of interest, do you know (and can you relate) why those apps need
> 100k/sec monotonically increasing timestamps?

This is sort of tangential, but depending on the need, this might be
of interest:  Recently I've added a new clock_id,
CLOCK_MONOTONIC_COARSE (as well as CLOCK_REALTIME_COARSE), which
return a HZ granular timestamp (same granularity as filesystem
timestamps). Its very fast to access, since there's no hardware to
touch, and is accessible via vsyscall.

The idea being, if your hitting clock_gettime 100k/sec but you really
don't have the need for nsec granular timestamps, it might provide a
really nice performance boost.

Here's the commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da15cfdae03351c689736f8d142618592e3cebc3

thanks
-john
