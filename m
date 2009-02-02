Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZBBJtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZBBJtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZBBJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:48:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:60282 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZBBJs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:48:58 -0500
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
In-Reply-To: <200902021014.10203.oliver@neukum.org>
References: <20090127001708.GA4815@nowhere>
	 <4986B205.2040807@s5r6.in-berlin.de> <1233565528.18767.80.camel@pasglop>
	 <200902021014.10203.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 20:46:33 +1100
Message-Id: <1233567993.18767.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 10:14 +0100, Oliver Neukum wrote:
> Am Monday 02 February 2009 10:05:28 schrieb Benjamin Herrenschmidt:
> > > Work which /may/ sleep longer, for example performs SCSI transactions,
> > > needs to go into a private workqueue or other kind of context.
> > 
> > Well, it's a bit silly to allocate a private workqueue with all it's
> > associated per CPU kernel threads for something as rare as resetting
> > your eth NIC ... or even SCSI error handling in fact.
> 
> How do you avoid a deadlock if SCSI error handling doesn't use
> a dedicated workqueue?

Something such as slow-work or async funcs (not sure about the later, I
have to look at the implementation) but the basic idea is to have a pool
of threads for "generic" delayed work, when its busy, pick another one,
and the pool itself should resize if there's too much pressure.

Ben.


