Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZIAQPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZIAQPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZIAQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:15:45 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:49035 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbZIAQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:15:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACjlnEqrR7PD/2dsb2JhbADEaYhBAZAFBYI4gWM
X-IronPort-AV: E=Sophos;i="4.44,313,1249257600"; 
   d="scan'208";a="200717978"
From: Roland Dreier <rdreier@cisco.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>
	<alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	<1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz>
	<4A96B997.1070001@nortel.com>
	<alpine.DEB.1.10.0908271257270.17470@gentwo.org>
	<alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
	<4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com>
	<4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com>
	<alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
	<alpine.DEB.1.10.0908281446520.7317@gentwo.org>
	<alpine.LFD.2.00.0908282100040.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908281551450.17784@gentwo.org>
	<alpine.LFD.2.00.0908282158100.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908281619520.15573@gentwo.org>
	<alpine.LFD.2.00.0908282231260.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908311517410.26046@V090114053VZO-1>
	<adavdk3q3nk.fsf@cisco.com>
	<alpine.DEB.1.10.0909011440210.12112@V090114053VZO-1>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Sep 2009 09:15:46 -0700
In-Reply-To: <alpine.DEB.1.10.0909011440210.12112@V090114053VZO-1> (Christoph
	Lameter's message of "Tue, 1 Sep 2009 14:42:29 -0400 (EDT)")
Message-ID: <adaskf6od3h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 16:15:46.0338 (UTC) FILETIME=[765EB820:01CA2B1F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Ok then these per cpu irqs are there to support something different? There
 > are per cpu irqs here. Seems to be hardware supported?

Yes, the driver now creates per-cpu IRQs for completions.  However if
you don't trigger any completion events then you won't get any
interrupts.  That's different from the workqueues, which are used to
poll the hardware for port changes and internal errors (and which are
single-threaded and can be put on whatever "system services" CPU you want)

 - R.
