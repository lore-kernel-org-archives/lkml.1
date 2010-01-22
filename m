Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0AVRm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0AVRm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443Ab0AVRm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:42:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:43738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab0AVRm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:42:26 -0500
Subject: RE: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event
 scheduling (v1)
From: Peter Zijlstra <peterz@infradead.org>
To: John McCalpin <mccalpin@tacc.utexas.edu>
Cc: "'Dan Terpstra'" <terpstra@eecs.utk.edu>,
       "eranian@google.com" <eranian@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ptools-perfapi@eecs.utk.edu" <ptools-perfapi@eecs.utk.edu>,
       "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "paulus@samba.org" <paulus@samba.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>
In-Reply-To: <CF3466DD76A94945B5723C073FE74B0A69E64117E6@MAIL02.austin.utexas.edu>
References: <4b5991c4.0c58560a.44d3.ffffeedc@mx.google.com>
	 <05F95E05F0394ED3B66F16ACA8ED4650@terpstrat60p>
	 <CF3466DD76A94945B5723C073FE74B0A69E64117E6@MAIL02.austin.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 18:42:01 +0100
Message-ID: <1264182121.4283.1549.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 11:33 -0600, John McCalpin wrote:

> * Think of the system as having four performance monitors per core
> *plus* four performance monitors for the "shared" structures on the
> chip (L3, crossbar, HyperTransport links, memory controllers).

Would have been nice to have them as a separately addressable pmu
instead of shadowing the logical cpu's pmu.

But that's all ancient history of course..

> There is an additional hazard when working with early K8 processors --
> a hardware bug causes the counts of all shared counters to be reset to
> zero any time any shared register is programmed.  This makes
> "protecting" users somewhat more difficult....

Could you qualify early k8 a bit more, it shouldn't be hard to add a
quirk for a specific set of cpus to read/reset all counters before
writing to the shared pmu.

