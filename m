Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZBBKDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZBBKDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBBKC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:02:58 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:56045 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZBBKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:02:58 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Date: Mon, 2 Feb 2009 11:03:45 +0100
User-Agent: KMail/1.9.10
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
References: <20090127001708.GA4815@nowhere> <200902021014.10203.oliver@neukum.org> <1233567993.18767.81.camel@pasglop>
In-Reply-To: <1233567993.18767.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021103.47596.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 02 February 2009 10:46:33 schrieb Benjamin Herrenschmidt:
> On Mon, 2009-02-02 at 10:14 +0100, Oliver Neukum wrote:
> > Am Monday 02 February 2009 10:05:28 schrieb Benjamin Herrenschmidt:
> > > > Work which /may/ sleep longer, for example performs SCSI transactions,
> > > > needs to go into a private workqueue or other kind of context.
> > > 
> > > Well, it's a bit silly to allocate a private workqueue with all it's
> > > associated per CPU kernel threads for something as rare as resetting
> > > your eth NIC ... or even SCSI error handling in fact.
> > 
> > How do you avoid a deadlock if SCSI error handling doesn't use
> > a dedicated workqueue?
> 
> Something such as slow-work or async funcs (not sure about the later, I
> have to look at the implementation) but the basic idea is to have a pool
> of threads for "generic" delayed work, when its busy, pick another one,
> and the pool itself should resize if there's too much pressure.

And all that without using GFP_KERNEL?

	Regards
		Oliver
