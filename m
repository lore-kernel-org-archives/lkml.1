Return-Path: <linux-kernel-owner+w=401wt.eu-S934383AbXC3Amb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbXC3Amb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 20:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934385AbXC3Amb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 20:42:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52079 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383AbXC3AmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 20:42:20 -0400
Message-ID: <460C5D24.608@us.ibm.com>
Date: Thu, 29 Mar 2007 17:43:16 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Organization: IBM LTC
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venki,

I have a dual-Woodcrest machine here with _PSD tables that specify that
cpufreq coordination between cores is done in hardware with
DOMAIN_COORD_TYPE_HW_ALL.  On this particular machine, CPU 0 and CPU 2
are on the same package, and it looks like they have to be at the same
frequency.

However, it seems that acpi_cpufreq_cpu_init() only sets policy->cpus to
the shared cpu mask if software coordination is required.  While this
does have the effect of letting the hardware do its coordination job as
advertised, it also means that a frequency change to CPU0 doesn't get
echoed to CPU2 as it should be, and affected_cpus is inaccurate.

This seems like a bug to me.  I can whip up a patch to set the policy
cpu mask in all cases and neuter all but one of the MSR/PCT writes if HW
coordination is desired so that HW coordination is preserved and sysfs
is accurate, but I'm curious to know if I've gotten it right.

--D
