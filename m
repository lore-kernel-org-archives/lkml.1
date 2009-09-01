Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZIALhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZIALhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZIALhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:37:18 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45134 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZIALhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:37:17 -0400
Date: Tue, 1 Sep 2009 17:07:04 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v4 PATCH 0/5]: cpuidle/POWER (REDISIGN): Introducing cpuidle to
	POWER.
Message-ID: <20090901113704.GG7599@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

******** This is an RFC, not for inclusion **********

This patchset introduces cpuidle infrastructure to POWER, prototyping
for pseries and currently in the process of porting to x86 and hence
will *not* build on x86/other POWER platforms.

This is to get initial comments on the redesign of my earlier implementation
which can be found at http://lkml.org/lkml/2009/8/27/124

Major changes from last iteration:
----------------------------------

* Cleanup drivers/cpuidle/cpuidle.c
	Currently, the cpuidle implementation has weakness in the
	framework where an exported pm_idle function pointer is
	manipulated by various subsystem. The proposed framework has
	a registration architecture to cleanly add and remove new idle
	routines from different subsystems.

* Introduce [un]register_idle_function() routines
        Implement a LIFO based approach for registering architecture
        dependent idle routines.

* Sample implementation of register_idle_function for pSeries


TODO:
-----

* Extend this prototype to cover x86 and other archs that use cpuidle.
        Currently, in x86, the cpu_idle() idle loop doesn't have a
        default idle loop to fall back to if pm_idle is NULL, unlike
        the corresponding implementation in pseries, where
        ppc_md.power_save can be NULL and there is a fallback.
        So we need to create a similar fork in cpu_idle() idle loop of
        x86.



Patches included in this series:
--------------------------------

1/5 - Cleanup drivers/cpuidle/cpuidle.c
2/5 - Implement routines to register and unregister idle function.
3/5 - Incorporate registering of idle loop for pSeries.
4/5 - Add Kconfig entry to enable cpuidle for POWER.
5/5 - Implement pSeries processor idle module.


Any comments on the design is welcome.

--arun
