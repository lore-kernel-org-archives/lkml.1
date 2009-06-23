Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZFWGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZFWGAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFWGAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:00:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:44014 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZFWGAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:00:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="424483108"
From: "Wang, Yong Y" <yong.y.wang@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Date: Tue, 23 Jun 2009 13:59:37 +0800
Subject: RE: perf_counter Atom patch
Thread-Topic: perf_counter Atom patch
Thread-Index: Acnzd7W+LJf0q1C+SPuJ7hbMoHeBlgANx2pQAAYF8EA=
Message-ID: <9F0C1DB20AFA954FA1DA05309350433D7B2585F4@pdsmsx503.ccr.corp.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wang, Yong Y 
> 
> > From: stephane eranian [mailto:eranian@googlemail.com] 
> > 
> > I would like to better understand what makes you think
> > this is the case.
> > 
> 
> Because I observed that the output of 'perf stat -e 0:0 -e 
> 0:1 -e 0:6 <cmd>'
> is always like below without the quirk.
> 
>  Performance counter stats for '<cmd>':
> 
>               0  cycles
>               0  instructions
>               0  bus-cycles
> 
> > Perfmon is working on Atom and there, fixed counters work perfectly:
> > $ head -6 /proc/cpuinfo
> > processor	: 0
> > vendor_id	: GenuineIntel
> > cpu family	: 6
> > model		: 28
> > model name	: Intel(R) Atom(TM) CPU  230   @ 1.60GHz
> > stepping	: 2
> > ...
> 
> My cpuinfo is below and the only difference I can see is 270 vs 230.
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 28
> model name      : Intel(R) Atom(TM) CPU N270   @ 1.60GHz
> stepping        : 2
> 
> > $ pfmon -v --us-c -e
> > unhalted_core_cycles,unhalted_reference_cycles,instructions_retired
> > noploop 10
> > [FIXED_CTRL(pmc16)=0xaaa pmi0=1 en0=0x2 any0=0 pmi1=1 en1=0x2 any1=0
> > pmi2=1 en2=0x2 any2=0] INSTRUCTIONS_RETIRED UNHALTED_CORE_CYCLES
> > UNHALTED_REFERENCE_CYCLES
> > [FIXED_CTR0(pmd16)]
> > [FIXED_CTR1(pmd17)]
> > [FIXED_CTR2(pmd18)]
> > noploop for 10 seconds
> > 15,902,604,169 UNHALTED_CORE_CYCLES
> > 15,902,586,180 UNHALTED_REFERENCE_CYCLES
> > 7,941,842,505 INSTRUCTIONS_RETIRED
> > 
> 
> Could you pls try to revert my patch, run 'perf stat -e 0:0 
> -e 0:1 -e 0:6 <cmd>' and see
> whether the counters count or not? I tried pfmon on my atom 
> box but it always runs into
> segfault. If the fixed counters work for you, I will ask Atom 
> hw foks here in Intel why this
> is the case and revise the code accordingly.
> 

I just found an Atom 230 based nettop in our lab and looks like the fixed counters
do not work. Below is the output on a kernel without my patch.

atom@atom-desktop:~$ head -n 6 /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Intel(R) Atom(TM) CPU  230   @ 1.60GHz
stepping        : 2
atom@atom-desktop:~$ ./perf stat -e 0:0 -e 0:1 -e 0:6 true

 Performance counter stats for 'true':

              0  cycles
              0  instructions
              0  bus-cycles

    0.004089458  seconds time elapsed.

Are you aware of any microcode update for the Atom processor you are using?
