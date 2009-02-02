Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZBBUqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZBBUqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZBBUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:46:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:45574 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZBBUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:46:27 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200902021103.47596.oliver@neukum.org>
References: <20090127001708.GA4815@nowhere>
	 <200902021014.10203.oliver@neukum.org> <1233567993.18767.81.camel@pasglop>
	 <200902021103.47596.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 07:44:17 +1100
Message-Id: <1233607457.18767.101.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Something such as slow-work or async funcs (not sure about the later, I
> > have to look at the implementation) but the basic idea is to have a pool
> > of threads for "generic" delayed work, when its busy, pick another one,
> > and the pool itself should resize if there's too much pressure.
> 
> And all that without using GFP_KERNEL?

Not too hard. There are options here, one is to keep always one thread
available in the pool that will create new ones, one is to hop via
keventd for the creation, which is still better than spending 200ms
resetting a network NIC, etc...

Ben.


