Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZA3O70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZA3O70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZA3O7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:59:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:35788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZA3O7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:59:17 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: cpufreq@vger.kernel.org
Subject: cpufreq on demand governor sampling rate restricted to HZ even on NO_HZ kernels
Date: Fri, 30 Jan 2009 15:59:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.11-HEAD_20090116074536_2c57617f-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200901301559.15170.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

depending on HZ set to:

100
250
1000

the ondemand governor is currently limited to poll the CPU load
and adjust the frequency (sampling rate sysfs variable) every:

200ms
80ms
20ms

This limitation does not consider NO_HZ which looks wrong?
If this is correct, can someone give me a pointer, I'd like
to understand why.

If NO_HZ can/should go down to 20ms polling and more (current
CPUs are able to switch fast enough, so that the ondemand governor
would calculate the default polling interval below 80ms for them),
this would hurt in respect of C-states at some point.

For performance reasons, one wants to poll as much as possible, for
powersaving reasons (C-states), one wants to poll as seldom as
possible.

I wonder whether it makes sense to dynamically adjust the polling
interval (e.g. by a hint (and initial wakeup) from the scheduler or
taking C-states into account) to:
  - increase the sampling rate, e.g. based on context switching
    activity
  - lower sampling rate when the system is idle (to gain
    full C-state efficiency)
Or in what other way deep C-states could be taken into account
in respect of ondemand polling?

Thanks,

     Thomas

