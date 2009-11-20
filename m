Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZKTSSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZKTSSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZKTSSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:18:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:61406 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbZKTSSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FL+2koIy8dQhySfgtJ0jXV7yANr16j/v/IifJVyetneZna1ODeQnynqTNfydoPWGp4
         FpimN/uqTxJw95tziEyUncC1eCC8qijf6zOcV4vcQdURqi/L8HIHBOQN6ibzQWtOO5Fu
         OHSv4JmKXfGz0uimy4QTLx79eYDgYAZGH47eY=
Date: Fri, 20 Nov 2009 21:18:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kvm hangs w/o nolapic
Message-ID: <20091120181815.GA8779@lenovo>
References: <1258715515.7094.51.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258715515.7094.51.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 12:11:55PM +0100, Johannes Berg wrote:
> My 2.6.32-rc7 kvm (both guest+host, x86_64) hangs w/o "nolapic" here:
> 
>   while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
>      cpu_relax();
> 
> because lapic_cal_loops never changes from -1.
> 
> Code was last changed by
> commit 2f04fa888d270951b9e0fe9e641ddd560d77ad1b
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Sun Aug 24 02:01:54 2008 -0700
> 
>     x86: apic copy calibrate_APIC_clock to each other in apic_32/64.c
> 
> but I haven't tested reverting that.
> 
> johannes

Hi Johannes,

It will be not easy to revert since the commit was "preparing to merge"
apic_32/64.c. It rather seems there is a problem with timer(s) other then
APIC's one (ie PIT, HPET, PM). And since you're under kvm -- it could be
a corner case as well.

I've just booted a latest -tip with kvm without problems.
I've been using

|
| QEMU PC emulator version 0.9.1 (kvm-84)
|

Perhaps you could capture console with "debug apic=debug") and to gather
more info? And .config?

	-- Cyrill
