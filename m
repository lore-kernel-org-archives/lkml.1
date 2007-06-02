Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXFBGnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXFBGnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 02:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXFBGnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 02:43:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbXFBGnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 02:43:46 -0400
Date: Sat, 2 Jun 2007 02:43:25 -0400
From: Dave Jones <davej@redhat.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Dependent CPU core speed reporting not updated with
	CPUFREQ_SHARED_TYPE_HW?
Message-ID: <20070602064325.GB7445@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org
References: <20070601184342.GA13751@tree.beaverton.ibm.com> <653FFBB4508B9042B5D43DC9E18836F5F5B11F@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5F5B11F@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 06:59:25PM -0700, Venki Pallipadi wrote:

 > Hmmm. How about having a new cpufreq_sysfs entry to say
 > these CPUs are frequency dependent in hardware.

Wait, wasn't this the entire purpose of affected_cpus in the first
place? So we could see which CPUs would be affected by a frequency
change?  What went wrong here?

 > affected_cpus today has a single cpufreq directory for all affected_cpus
 > and we coordinate all CPUs in software. To change freq, we will have to
 > move among all affected_cpus and write an MSR.

This I think is where the problem started.  That these remained
independant.  Changing one should also affect the others that it
'affects'. Is that not the case?

 > Hardware coordination basically tells us that kernel can control
 > frequency
 > percpu, but underneath hardware will pick highest requested freq among a
 > group of CPUs. Instaed of handling this case as the existing software
 > coordination case above, we can add a new entry in cpufreq /sysfs
 > denoting
 > hardware coordinated CPU group.
 > 
 > Though it will be confusing with too many interfaces, I feel this is the
 > right way to go about here.

If 'affected_cpus' doesn't do the right thing, I'd vote for making it
do so over adding more interfaces.

	Dave

-- 
http://www.codemonkey.org.uk
