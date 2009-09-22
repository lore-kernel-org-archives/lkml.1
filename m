Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZIVHYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZIVHYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZIVHYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:24:54 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:34143 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZIVHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:24:53 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v5 RFC PATCH 0/7]: cpuidle/x86/POWER (REDESIGN): Cleanup idle
 power management code in x86, cleanup drivers/cpuidle/cpuidle.c and
 introduce cpuidle to POWER.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090922053314.GA6417@linux.vnet.ibm.com>
References: <20090922053314.GA6417@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 09:25:59 +0200
Message-Id: <1253604359.8439.278.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Much better :-)


But I'm puzzled by all the per-cpu-ish-ness of the stuff. Why would you
need to register things on a per-cpu basis?

Also:


+       list_for_each(pos, &per_cpu(cpuidle_devices_list, cpu)) {
+               temp_dev = container_of(pos, struct cpuidle_device,
+                                       percpu_list[cpu]);
+               if (dev == temp_dev) {
+                       list_del(&temp_dev->percpu_list[cpu]);
+                       cpuidle_remove_state_sysfs(temp_dev);
+               }
+       }

Looks buggy, either you want to break out of the loop on dev ==
temp_dev, or you want to use list_for_each_safe().



