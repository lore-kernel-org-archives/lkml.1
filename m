Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZGFLT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZGFLT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZGFLTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:19:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZGFLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:19:20 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [patch 1/4] cpufreq: Eliminate the recent lockdep warnings in cpufreq
Date: Mon, 6 Jul 2009 13:19:20 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20090703000829.735976000@intel.com> <200907031341.19141.trenn@suse.de> <7E82351C108FA840AB1866AC776AEC4669BFF050@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4669BFF050@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907061319.22660.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 16:28:43 Pallipadi, Venkatesh wrote:
> 
...
> >I still do not see the need of "dbs_mutex protects data in 
> >dbs_tuners_ins
> >from concurrent changes", though. If someone enlightens me, that would
> >be appreciated.
> 
> OK. Consider these two happening in parallel.
> echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice
> echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/ignore_nice
Hm, I just consider parallel configuration, especially with different
values as a userspace bug anyway.

> As they are coming from different cpu, rwsem wont protect us and 
> without the dbs_mutex, end state after this can will be unpredictable.
> prev_cpu_idle and prev_cpu_nice can end up with wrong values where
> only one of them is set etc. That will affect the ondemand algorithm.
For one sample in this case.
But I see that it should be made 100%
bulletproof and even userspace is doing wrong things already you want to
have a defined state. A separate mutex, uncoupled from .governor() would make 
things easier, but I wait until it's clear what cleanups are going into which 
kernel and will suggest another cleanup to only allow
global dbs_tuners on top for .31 or further future.

Thanks,

    Thomas
