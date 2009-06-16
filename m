Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZFPQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZFPQXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZFPQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:23:14 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:56163 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZFPQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:23:13 -0400
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 2/4] cpu: sysfs interface for hotplugging bunch of
 CPUs.
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
 <20090616053849.30891.17453.stgit@sofia.in.ibm.com>
From: Nathan Lynch <ntl@pobox.com>
Date: Tue, 16 Jun 2009 11:22:56 -0500
In-Reply-To: <20090616053849.30891.17453.stgit@sofia.in.ibm.com> (Gautham R.
 Shenoy's message of "Tue\, 16 Jun 2009 11\:08\:49 +0530")
Message-ID: <m3iqiwup0f.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: FEA98BBE-5A91-11DE-8672-97731A10BFE7-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy <ego@in.ibm.com> writes:
> echo 2,3 > /sys/devices/system/cpu/offline #Offlines CPUs 2 and 3
> echo 4 > /sys/devices/sytem/cpu/offline    #Offlines CPU 4
> echo 2-4 > /sys/devices/system/cpu/online  #Onlines CPU 2,3,4
>
> This patch changes the permissions of these sysfs files from 0444 to 0644.
> It provides a dummy store function, which currently parses the input
> provided by the user and copies them to another debug cpumask structure,
> which can be accessed using the sysfs interfaces:
> 	/sys/devices/system/cpu/debug_offline
> and
> 	/sys/devices/system/cpu/debug_online
>
> Thus on performing a
> 	echo 2,3 > /sys/devices/system/cpu/offline
> the operation
> 	cat /sys/devices/system/cpu/debug_offline
> should yield
> 	2-3
> as the result.

These debug_(on|off)line attributes aren't intended to be in the final
result, are they?  They don't seem useful beyond the development phase
of this feature...
