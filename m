Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYIFXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYIFXvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYIFXum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38030 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753029AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:36 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 00/13] smp: reduce stack requirements for genapic send_IPI_mask functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Note: all these changes require some more testing but I wanted to solicit
comments before then, hence the "RFC" in the subject line. -thanks! Mike]

  * Change the genapic->send_IPI_mask function to accept cpumask_t pointer.

  * Add for_each_online_cpu_mask_nr to eliminate a common case of needing
    a temporary on-stack cpumask_t variable.

  * Change send_IPI_mask function in xen to use for_each_online_cpu_mask_nr().

  * Add cpumask_ptr operations.

  * Add get_cpumask_var debug operations.

  * Add global allbutself PER_CPUMASK variable.

  * Remove as many on-stack cpumask_t variables in kernel/sched.c

  * Remove as many on-stack cpumask_t variables in acpi-cpufreq.c

  * Remove as many on-stack cpumask_t variables in io_apic.c


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
