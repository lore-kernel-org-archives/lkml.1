Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZBBGCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZBBGCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZBBGCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:02:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:43882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZBBGCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:02:21 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090202022414.GA5006@nowhere>
References: <20090127001708.GA4815@nowhere>
	 <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere>
	 <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere>
	 <1233524261.18767.60.camel@pasglop>  <20090202022414.GA5006@nowhere>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 17:00:43 +1100
Message-Id: <1233554443.18767.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 03:24 +0100, Frederic Weisbecker wrote:
> On Mon, Feb 02, 2009 at 08:37:41AM +1100, Benjamin Herrenschmidt wrote:
> > 
> > > I don't know, most of those I've looked on are not documented about the reason
> > > for a private workqueue. I guess most of them can use the usual kevent.
> > 
> > The main problem with kevent is that it gets clogged up.
> 
> 
> I don't think so. Here is a snapshot of the workqueue tracer in my
> box currently:

That's not quite what I meant ... 

The main problem with keventd I'd say is that it's used in all sort of
exeptional code path (ie, driver reset path, error handling, etc...) for
things that will msleep happily for tenth milliseconds, that sort of
thing.

IE. It will be pretty responsive -in general- but can suffer form
horrible latencies every now and then.

Cheers,
Ben.

