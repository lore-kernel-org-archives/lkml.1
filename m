Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXJZDBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXJZDBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbXJZDBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:01:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:60781 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbXJZDBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uBhAqHpbBwss3fQMTUVjxQdaiSisau7/3Ov0F4mcwbaBqg6fL4pl//a060IhZv9d4coX0TnDvbjDDJ16OWlvVLzXFD9egSdZKeoxxYxq3g/q6INQ7NIhMq6oCZiyC/xuygoP42kCMQaCcv5l+oQI3jrs5ZHWSkZDsvgr/cW+CqE=
Message-ID: <19b271a20710252001r3a1b34fqf138b3b013f93aa9@mail.gmail.com>
Date: Thu, 25 Oct 2007 23:01:38 -0400
From: "Joshua Roys" <roysjosh@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: 2.6.23 hang, unstable clocksource?
Cc: "john stultz" <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4721269D.6030208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19b271a20710161331m35c02a18p6967506ad0a6764c@mail.gmail.com>
	 <1f1b08da0710251610i2b0e1c21g8b68c721d65af756@mail.gmail.com>
	 <4721269D.6030208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 10/25/2007 07:10 PM, john stultz wrote:
> >
> > What was the last kernel version you were using that didn't show the issue?
> > Couple of things to try below:
> >
> >
> > Could you disable CONFIG_HANGCHECK_TIMER  in your .config? Just to
> > make sure it isn't flipping out.
> >
> >
> > Another thing to try: Boot with "clocksource=hpet" and verify that
> > avoids or triggers the issue. If it triggers the issue does it go away
> > with "clocksource=acpi_pm"?
> >
>
> We're seeing reports of this in Fedora 8, kernel 2.6.23;
>
> https://bugzilla.redhat.com/show_bug.cgi?id=319441
>

Hello,

I tried 2.6.21 and still had the same problem, I was going to back
farther but then I decided to try a few things with my 2.6.23 config.

$ diff config-2.6.23 newconfig-2.6.23-gentoo
140,151d139
< CONFIG_CPU_FREQ=y
< CONFIG_CPU_FREQ_TABLE=y
< CONFIG_CPU_FREQ_DEBUG=y
< CONFIG_CPU_FREQ_STAT=y
< CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
< CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
< CONFIG_CPU_FREQ_GOV_USERSPACE=y
< CONFIG_CPU_FREQ_GOV_ONDEMAND=y
< CONFIG_X86_ACPI_CPUFREQ=y
< CONFIG_X86_P4_CLOCKMOD=y
< CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
< CONFIG_X86_SPEEDSTEP_LIB=y
456a445,446
> CONFIG_SQUASHFS=m
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
488,490d477
< CONFIG_DEBUG_KERNEL=y
< CONFIG_DETECT_SOFTLOCKUP=y
< CONFIG_SCHED_DEBUG=y
492d478
< CONFIG_FORCED_INLINING=y

config-2.6.23 is the vanilla kernel's config that was experiencing the
hangs.  2.6.23-gentoo was also experiencing the hangs.  Then, I
disabled CPU frequency scaling (and a few other things I guess,
looking at the diff..) and recompiled and..  no hangs yet.  Uptime 3
and a half days.

If you wish I can use a vanilla kernel.

Joshua Roys
