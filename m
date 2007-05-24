Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbXEXQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbXEXQtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXEXQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:49:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:40048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbXEXQs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:48:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,574,1170662400"; 
   d="scan'208";a="90162834"
Date: Thu, 24 May 2007 09:45:38 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, colpatch@us.ibm.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070524164538.GA13301@linux-os.sc.intel.com>
References: <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4655423E.6000202@bigpond.net.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 12:43:58AM -0700, Peter Williams wrote:
>Peter Williams wrote:
>> The relevant code, find_busiest_group() and find_busiest_queue(), has a 
>> lot of code that is ifdefed by CONFIG_SCHED_MC and CONFIG_SCHED_SMT and, 
>> as these macros were defined in the kernels I was testing with, I built 
>> a kernel with these macros undefined and reran my tests.  The 
>> problems/anomalies were not present in 10 consecutive tests on this new 
>> kernel.  Even better on the few occasions that a 3/1 split did occur it 
>> was quickly corrected to 2/2 and top was reporting approx 49% of CPU for 
>> all spinners throughout each of the ten tests.
>> 
>> So all that is required now is an analysis of the code inside the ifdefs 
>> to see why it is causing a problem.
>
>
>Further testing indicates that CONFIG_SCHED_MC is not implicated and
>it's CONFIG_SCHED_SMT that's causing the problem.  This rules out the
>code in find_busiest_group() as it is common to both macros.
>
>I think this makes the scheduling domain parameter values the most
>likely cause of the problem.  I'm not very familiar with this code so 
>I've added those who've modified this code in the last year or 
>so to the 
>address of this e-mail.

What platform is this? I remember you mentioned its a 2 cpu box. Is it
dual core or dual package or one with HT?

thanks,
suresh
