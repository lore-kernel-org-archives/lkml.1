Return-Path: <linux-kernel-owner+w=401wt.eu-S1161490AbXDXWFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490AbXDXWFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161772AbXDXWFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:05:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:31497 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161490AbXDXWFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N//NcetrW2OHsdasx9xB4AAMfbtgrGbPou1EBlek2AGCqyRug/H65mlbPAjrWjZOH+kFsyJ33s8V2XnSwz+xXXJJh63oSE1ehXTP7Iq0kHtm/lFHAO1uJzYE9C6Tf7hApwdLOzWGH0sTn8ppg77CUb46N9tMeBf64V9zKWkC/Z0=
Message-ID: <29495f1d0704241505p62140160o52d83e383106bf8e@mail.gmail.com>
Date: Tue, 24 Apr 2007 15:05:36 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Dave Jones" <davej@redhat.com>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
In-Reply-To: <20070424211253.GG23598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
	 <20070424211253.GG23598@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Dave Jones <davej@redhat.com> wrote:
> On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
>  > The following patches should allow selection of conservative, powersave, and
>  > ondemand in the kernel configuration.
>
> This has been rejected several times already.
> Ondemand and conservative isn't a viable governor for all cpufreq
> implementations (ie, ones with high switching latencies).

This piques my curiosity -- some governors don't work with some
cpufreq implementations. Are those implementations in the kernel or in
userspace? If in the kernel, then perhaps there should be some
dependency expressed there in Kconfig between cpufreq implementation
and the available governors (not just whether the governor can be the
default or not). If that is already expressed, then the available
*default*s should also have their dependency so expressed.

I guess I don't see the point of *not* allowing users to select a
different governor as default at compile-time, if they can change it
at run-time?

The distros would simply not change the DEFAULT selection, but users
that build their own kernels could change it as they wanted.

I guess the issue is, if by allowing a different DEFAULT selection
(albeit one that wouldn't change for existing .configs, I assume), are
we going to break existing setups. It doesn't seem like we would,
*unless* the user goes and changes the default. And they went and
changed it to a default that doesn't work, but that they could easily
have checked doesn't work with their cpufreq implementation by
changing it at run-time in their current kernel. And they are root...

> Also, see the
> comment in the Kconfig a few lines above where you are adding this.

Are these governors unfixable? If

"it is not currently possible to set the other governors (such as
ondemand) as the default, since if they fail to initialise, cpufreq
will be left in an undefined state."

is true, presumably "userspace" and "performance" are so written so as
to not leave cpufreq in an undefined state? Could the same be done for
ondemand and powersave?

Just looking for more info -- feel free to just point me at the archives.

Thanks,
Nish
