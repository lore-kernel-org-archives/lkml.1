Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0BWQat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:30:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0BWQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:30:48 -0500
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
In-Reply-To: <1266942281.11845.521.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1265403478.6089.41.camel@jschopp-laptop>
	 <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org>
	 <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org>
	 <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org>
	 <23662.1266905307@neuling.org>  <1266942281.11845.521.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 17:30:26 +0100
Message-ID: <1266942626.11845.527.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 17:24 +0100, Peter Zijlstra wrote:
> 
>         busiest_cpu = group_first_cpu(sds->busiest);
>         if (cpu_rq(this_cpu)->nr_running || this_cpu > busiest_cpu)
>                 return 0; 

Hmm, we could change the bit in find_busiest_group() to:

  if (idle == CPU_IDLE && check_asym_packing())

and skip the nr_running test..

