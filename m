Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZBDJxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZBDJxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZBDJxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:53:41 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58212 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZBDJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:53:41 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Date: Wed, 4 Feb 2009 10:54:29 +0100
User-Agent: KMail/1.9.10
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
References: <20090127001708.GA4815@nowhere> <200902021103.47596.oliver@neukum.org> <1233607457.18767.101.camel@pasglop>
In-Reply-To: <1233607457.18767.101.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041054.31531.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 02 February 2009 21:44:17 schrieb Benjamin Herrenschmidt:
> 
> > > Something such as slow-work or async funcs (not sure about the later, I
> > > have to look at the implementation) but the basic idea is to have a pool
> > > of threads for "generic" delayed work, when its busy, pick another one,
> > > and the pool itself should resize if there's too much pressure.
> > 
> > And all that without using GFP_KERNEL?
> 
> Not too hard. There are options here, one is to keep always one thread
> available in the pool that will create new ones, one is to hop via
> keventd for the creation, which is still better than spending 200ms
> resetting a network NIC, etc...

But how does that solve the underlying problem of not being
allowed to hit the block layer? It seems to me you cannot do
without dedicated threads for block error handling. In fact, given
how rare this is, why not start one and share it?

	Regards
		Oliver

