Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZGCPa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZGCPa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZGCPaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:30:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51152 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbZGCPah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:30:37 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 11:30:36 EDT
Message-Id: <20090703143705.997230857@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 03 Jul 2009 10:37:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 2.6.30 0/4] Fix cpufreq locking dependency
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  3 Jul 2009 15:11:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
