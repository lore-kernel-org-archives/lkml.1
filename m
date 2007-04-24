Return-Path: <linux-kernel-owner+w=401wt.eu-S1031010AbXDXA7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031010AbXDXA7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031006AbXDXA7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:59:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:6850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031010AbXDXA7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,444,1170662400"; 
   d="scan'208"; a="232749811:sNHT21182084"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [REPORT] cfs-v4 vs sd-0.44
Date: Mon, 23 Apr 2007 17:59:06 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <462D37D2.3060208@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [REPORT] cfs-v4 vs sd-0.44
Thread-Index: AceF/42qK2+NWlpkQoyN7dyhJHJXKwABD2Ag
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Juliusz Chroboczek" <jch@pps.jussieu.fr>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Davidsen" <davidsen@tmr.com>, "Willy Tarreau" <w@1wt.eu>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, <caglar@pardus.org.tr>,
       "Gene Heskett" <gene.heskett@gmail.com>
X-OriginalArrivalTime: 24 Apr 2007 00:59:08.0071 (UTC) FILETIME=[C32E6B70:01C7860B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if we've discussed this or not. Since both CFS and SD claim
to be fair, I'd like to hear more opinions on the fairness aspect of
these designs. In areas such as OS, networking, and real-time, fairness,
and its more general form, proportional fairness, are well-defined
terms. In fact, perfect fairness is not feasible since it requires all
runnable threads to be running simultaneously and scheduled with
infinitesimally small quanta (like a fluid system). So to evaluate if a
new scheduling algorithm is fair, the common approach is to take the
ideal fair algorithm (often referred to as Generalized Processor
Scheduling or GPS) as a reference model and analyze if the new algorithm
can achieve a constant error bound (different error metrics also exist).
I understand that via experiments we can show a design is reasonably
fair in the common case, but IMHO, to claim that a design is fair, there
needs to be some kind of formal analysis on the fairness bound, and this
bound should be proven to be constant. Even if the bound is not
constant, at least this analysis can help us better understand and
predict the degree of fairness that users would experience (e.g., would
the system be less fair if the number of threads increases? What happens
if a large number of threads dynamically join and leave the system?).

  tong
