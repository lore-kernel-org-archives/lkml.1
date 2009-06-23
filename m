Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZFWJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZFWJK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZFWJKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:10:00 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:24633 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZFWJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:09:59 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter Atom patch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: eranian@gmail.com, "Wang, Yong Y" <yong.y.wang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090623083420.GB23534@ywang-moblin2.bj.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
	 <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
	 <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
	 <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
	 <20090623083420.GB23534@ywang-moblin2.bj.intel.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 11:10:05 +0200
Message-Id: <1245748205.19816.1550.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 16:34 +0800, Yong Wang wrote:
> > you could simply consider having 0 fixed counters and everything else would work
> > as expected. But there is a catch, unfortunately, in that there is erratum AE49
> > which says that there is only one enable bit to control the two generic counters
> > on Core Duo/Solo.

Ah, that's similar to P6 like machines. The P6 docs say that to disable
a counter you should simply write all zeros (except the EN bit for ctr0)
to the control register (IIRC).

I suppose we could do something similar on these errata cores, make
x86_pmu_disable_counter() write ARCH_PERFMON_EVENTSEL0_ENABLE instead.

Would that work?

