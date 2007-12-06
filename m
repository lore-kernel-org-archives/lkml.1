Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbXLFS1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbXLFS1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLFS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:27:13 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:28765 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXLFS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:27:12 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Joachim Fenkes <fenkes@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Message-Flag: Warning: May contain useful information
References: <200712061607.20004.fenkes@de.ibm.com>
	<200712061648.24806.arnd@arndb.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 06 Dec 2007 10:27:09 -0800
In-Reply-To: <200712061648.24806.arnd@arndb.de> (Arnd Bergmann's message of "Thu, 6 Dec 2007 16:48:23 +0100")
Message-ID: <ada7ijrd6gy.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Dec 2007 18:27:09.0982 (UTC) FILETIME=[9D1413E0:01C83835]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +               ehca_lock_hcalls = !(cur_cpu_spec->cpu_user_features
 > > +                                    & PPC_FEATURE_ARCH_2_05);

 > We already talked about this yesterday, but I still feel that checking the
 > instruction set of the CPU should not be used to determine whether a
 > specific device driver implementation is used int hypervisor.

I had the same reaction... is testing cpu_user_features really the
best way to detect this issue?

I'll hold off applying this for a few days so you guys can decide the
best thing to do.  We'll definitely get some fix into 2.6.24 but we
have time to make a good decision.

 > Regarding the performance problem, have you checked whether converting all
 > your spin_lock_irqsave to spin_lock/spin_lock_irq improves your performance
 > on the older machines? Maybe it's already fast enough that way.

It does seem that the only places that the hcall_lock is taken also
use msleep, so they must always be in process context.  So you can
safely just use spin_lock(), right?

 - R.
