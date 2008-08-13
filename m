Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYHMUTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYHMUTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYHMUS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:18:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28492 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYHMUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YqLAfAuXAq41O2Y3vItQ0LS5YeXxSTogspkbRrUboAXS8ANohYT9ZsCwULiRpxrBd3
         CQPWPHqSVjYL4kBHcvP0R2sjuOLL1nbMMXvG8Goq4RzveFHob5nuP7tD6KubPrqWT6Jt
         a1s2qq/HRJ7g/ydqXiUXyp4IGy0sLuRJS9exc=
Message-ID: <64bb37e0808131318j81ba372t8a5f089e33f1dc32@mail.gmail.com>
Date: Wed, 13 Aug 2008 22:18:56 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mark Langsdorf" <mark.langsdorf@amd.com>
In-Reply-To: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 4:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Things really _have_ calmed down, and hopefully we've also resolved a lot
> of the regressions in -rc3.

I found a new one in -rc3 vs. -rc2.
Only one of my cpus seems to powered down by cpufreq, because the
topology gets filled out wrong:

correct with -rc2:
#grep . /sys/devices/system/cpu/cpu*/cpufreq/affected_cpus
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0 1
/sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:0 1
/sys/devices/system/cpu/cpu2/cpufreq/affected_cpus:2 3
/sys/devices/system/cpu/cpu3/cpufreq/affected_cpus:2 3
(The system has 2 dual core Opterons)

wrong with -rc3:
#grep . /sys/devices/system/cpu/cpu*/cpufreq/affected_cpus
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0 1
/sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:0 1
/sys/devices/system/cpu/cpu2/cpufreq/affected_cpus:0 1
/sys/devices/system/cpu/cpu3/cpufreq/affected_cpus:0 1

I bisected this bug down to these commits:
> Mark Langsdorf (2):
>      [CPUFREQ][1/2] whitespace fix for powernow-k8
>      [CPUFREQ][2/2] preregister support for powernow-k8

HTH

Torsten
