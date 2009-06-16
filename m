Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZFPQHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZFPQHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZFPQHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:07:06 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:49906 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZFPQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:07:04 -0400
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 1/4] powerpc: cpu: Reduce the polling interval in
 __cpu_up()
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
 <20090616053844.30891.79173.stgit@sofia.in.ibm.com>
From: Nathan Lynch <ntl@pobox.com>
Date: Tue, 16 Jun 2009 11:06:45 -0500
In-Reply-To: <20090616053844.30891.79173.stgit@sofia.in.ibm.com> (Gautham R.
 Shenoy's message of "Tue\, 16 Jun 2009 11\:08\:44 +0530")
Message-ID: <m3r5xkupre.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: BCF017F8-5A8F-11DE-882A-97731A10BFE7-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc linuxppc-dev if you want the powerpc maintainer to pick this
up.

Gautham R Shenoy <ego@in.ibm.com> writes:
> The cpu online operation on a powerpc today takes order of 200-220ms. Of
> this time, approximately 200ms is taken up by __cpu_up(). This is because
> we poll every 200ms to check if the new cpu has notified it's presence
> through the cpu_callin_map. We poll every 200ms until the new cpu sets
> the value in cpu_callin_map or 5 seconds elapse, whichever comes earlier.
>
> However, the time taken by the new processor to indicate it's presence has
> found to be less than a millisecond

Only with your particular configuration (which is not identified).  It
can take much longer than 1ms on others.

> Keeping this in mind, reduce the
> polling interval from 200ms to 1ms while retaining the 5 second
> timeout.

Ack on the patch, but the changelog needs work.  I assume your
observations are from a pseries system -- please state this in the
changelog ("powerpc" is too broad), along with the processor model and
whether the LPAR's processors were configured in dedicated or shared
mode.

