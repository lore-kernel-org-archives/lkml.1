Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0CAU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:59:12 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:42882 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0CAU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=p4HWBRSA6tUi6MtcEzJf7U/bcI1UdoUS7ZBeO8XlUZl4HZsTDQFPp9/erXnejlJFca
         ZWPpFpWkGRM2ig0Kzso1b7lFvo4OkfpX/KRZegOFlM4s59IRWlAJ9Ka5uoeWH5hOSdhh
         o+/ZhfdDYJKKmox3Jx+BqwPD7/scz7Cg/kw0E=
MIME-Version: 1.0
In-Reply-To: <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
References: <4B8B901E.4050302@ladisch.de>
	 <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
Date: Mon, 1 Mar 2010 12:59:06 -0800
X-Google-Sender-Auth: d4f15f7ec372f61b
Message-ID: <1f1b08da1003011259yed7c61bvb18071eb8e465bca@mail.gmail.com>
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: john stultz <johnstul@us.ibm.com>
To: Magnus Lynch <maglyx@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 12:24 PM, Magnus Lynch <maglyx@gmail.com> wrote:
> Clemens Ladisch wrote:
>> A ioctl to read the main counter would just duplicate clock_gettime(),
>> but I cannot see any benefit over that.
>
> In fact for my situation I attempted using clock_gettime first and found it
> unsuitable. Specifically, my case is finding a substitute for RDTSC as a
> constant-rate counter for use in correcting real-time clock drift. This is for
> a CPU without constant TSC, as many are; and I was patching DJ Bernstein's
> excellent program clockspeed to be workable in such a case.
>
> Calculating the real time tick rate of clock_gettime using CLOCK_MONOTONIC
> suspiciously yielded a rate almost exactly 1GHz, which seemed to imply some
> feedback relative to real time was happening and thus wouldn't be reliably
> constant rate in the face of slewing the clock. Whatever the reason, in fact
> it wasn't and trying to depend on it as a constant rate timer while using
> adjtime quickly led to inaccuracies... Which led me to HPET as a solution,
> which worked swimmingly.
>
> I do now see there's another clockid, CLOCK_MONOTONIC_RAW, whose name implies
> it might work for me. I'll try it and see.

Yes, CLOCK_MONOTONIC_RAW was added specifically to create a hardware
agnostic interface that provided a 1:1 ratio to the hardware cycle
counter used by the timekeeping core. No NTP corrections or slewing
are applied and it isn't affected by settimeofday calls.

Let me know if you run into any trouble with it.
thanks
-john
