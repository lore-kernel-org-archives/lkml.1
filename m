Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZD2Rwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZD2Rwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZD2Rwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:52:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:38044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZD2Rw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,267,1239001200"; 
   d="scan'208";a="452642180"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Wed, 29 Apr 2009 10:52:26 -0700
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnI5zemTo/YbZZ3SSiz5cN/3QDI3gACgrpQ
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A64380@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	 <20090429002930.b786348b.akpm@linux-foundation.org>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63F45@azsmsx501.amr.corp.intel.com>
	 <20090429090706.bc5f462f.akpm@linux-foundation.org>
 <1241022336.8021.573.camel@laptop>
In-Reply-To: <1241022336.8021.573.camel@laptop>
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

Peter Ziljstra writes:
>
>I've had several reports about the resched-ipi going in overdrive, but
>nobody bothered to bisect it, nor have I yet done so -- no clear ideas
>on why it is doing so.
>
>I'll put it somewhere higher on the todo list.

FWIW, here is the interrupt data I was referring to.  The kernel delta refers to the difference in /proc/interrupts between the start and end of the run.  All database processes are running SCHED_RR.

                               2.6.24.2   2.6.30-rc3 
                                 delta       delta    % change
PCI-MSI-edge    qla2xxx         5270060     6118088      16.1%
PCI-MSI-edge    qla2xxx         5630742     5439656      -3.4%
PCI-MSI-edge    qla2xxx         5836425     5938014       1.7%
PCI-MSI-edge    qla2xxx         5774269     6007126       4.0%
PCI-MSI-edge    qla2xxx         5239457     5774888      10.2%
PCI-MSI-edge    qla2xxx         5965193     5424013      -9.1%
PCI-MSI-edge    eth0           31404141    32443614       3.3%
PCI-MSI-edge    eth1               1754        1453     -17.2%
Non-maskable interrupts        14041623    12980424      -7.6%
Local timer interrupts         27948168    28911532       3.4%
Rescheduling interrupts         1905119     4226516     121.9%
Function call interrupts            210          49     -76.7%
TLB shootdowns                      684        1455     112.7%

