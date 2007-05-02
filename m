Return-Path: <linux-kernel-owner+w=401wt.eu-S1766815AbXEBRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766815AbXEBRJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766816AbXEBRJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:09:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52362 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766815AbXEBRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:08:59 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] powerpc: perfmon2 prereqs
Date: Wed, 2 May 2007 12:08:57 -0500
User-Agent: KMail/1.9.5
Cc: Carl Love <carll@us.ibm.com>, Stephane Eranian <eranian@hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021208.59068.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of a couple patches I posted about a month ago related to 
porting perfmon2 to powerpc. I wanted to see if there were any further 
comments on these patches, and also wanted to ask if these should be 
submitted separately to the ppc kernel maintainers, or if they should be kept 
with the perfmon2 patches until those are submitted.

The first patch adds an smp_call_function_single() routine for powerpc. In 
2.6.21, there's a prototype for this routine in include/linux/smp.h, and it 
is implemented on i386, ia64, and x86-64. Since this routine is very similar 
to the existing smp_call_function() routine, the common portions have been 
pulled out into __smp_call_function(). Perfmon2 uses this unload a context 
that's loaded on a CPU other than the one that's performing the close-context 
routine.

The second patch changes the powerpc version of topology_init() from an 
__initcall to a subsys_initcall, which matches the definition of 
topology_init() on all other architectures. Perfmon2's initialization is done 
as a subsys_initcall, but it fails to set up its sysfs information if 
topology_init() has not yet run. Changing perfmon2 to an __initcall() was 
discussed, but we came to the conclusion that this would not work because the 
perfmon2 core must be initialized before any of its sub-modules. These 
sub-modules are located in arch/*/perfmon/, and thus if they are built 
statically they would run their module_init routines before the perfmon2 core 
ran its __initcall routine.

We have been running tests with these patches for the last few weeks on Cell 
and Power5 systems without any problems.

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
