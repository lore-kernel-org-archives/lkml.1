Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZGCPzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZGCPzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZGCPzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:55:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41317 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbZGCPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:55:40 -0400
Message-Id: <20090703152514.903448283@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 03 Jul 2009 11:25:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 2.6.30 0/4] Fix cpufreq locking dependency (resend)
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  3 Jul 2009 15:55:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, quilt mail problems in the previous post, here is the resend)

Hi,

Here is a patchset applying on 2.6.30 which should fix the cpufreq locking
dependency. Sadly, my two main test machines does not seem to support cpufreq,
so I have only been able to perform very light testing. (I can't afford to lock
down my laptop right now).

I went for the most straightforward fix I could think of and kept the current
locking structure. As you will see, the second patch cleans up the error
handling paths of cpufreq add dev, which were a total mess.

As a general recommendation, creating scripts which does, concurrently :

cpu hotplug up/down
cpufreq sysfs actions
change between cpufreq governors
add governors on random CPU numbers

will likely help stress-testing cpufreq locking. I really did not like what I've
seen there. It looked _very_ fragile.

Hopefully this will be better with this patches, but again, testing is welcome.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
