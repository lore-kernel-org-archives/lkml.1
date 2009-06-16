Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbZFPQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbZFPQhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760605AbZFPQh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:37:29 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40545 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760564AbZFPQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:37:28 -0400
Date: Tue, 16 Jun 2009 22:07:23 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 1/4] powerpc: cpu: Reduce the polling interval in
	__cpu_up()
Message-ID: <20090616163723.GB6005@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090616053844.30891.79173.stgit@sofia.in.ibm.com> <m3r5xkupre.fsf@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r5xkupre.fsf@pobox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:06:45AM -0500, Nathan Lynch wrote:
> Please cc linuxppc-dev if you want the powerpc maintainer to pick this
> up.

Will do it. I still need to test this patch across the different
configurations. I posted it here just so that we get a rough idea
regarding what we're looking at.

Thanks for taking a look at this one!
> 
> Gautham R Shenoy <ego@in.ibm.com> writes:
> > The cpu online operation on a powerpc today takes order of 200-220ms. Of
> > this time, approximately 200ms is taken up by __cpu_up(). This is because
> > we poll every 200ms to check if the new cpu has notified it's presence
> > through the cpu_callin_map. We poll every 200ms until the new cpu sets
> > the value in cpu_callin_map or 5 seconds elapse, whichever comes earlier.
> >
> > However, the time taken by the new processor to indicate it's presence has
> > found to be less than a millisecond
> 
> Only with your particular configuration (which is not identified).  It
> can take much longer than 1ms on others.
> 
> > Keeping this in mind, reduce the
> > polling interval from 200ms to 1ms while retaining the 5 second
> > timeout.
> 
> Ack on the patch, but the changelog needs work.  I assume your
> observations are from a pseries system -- please state this in the
> changelog ("powerpc" is too broad), along with the processor model and
> whether the LPAR's processors were configured in dedicated or shared
> mode.

Will send these details with the patch separately Ccing linux-ppcdev list.

-- 
Thanks and Regards
gautham
