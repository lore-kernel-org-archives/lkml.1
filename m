Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYDSOxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYDSOxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYDSOxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:53:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39015 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYDSOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:53:15 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080418142949.GB3922@redhat.com>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins>
	 <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins>
	 <20080418142949.GB3922@redhat.com>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 16:52:26 +0200
Message-Id: <1208616747.6452.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 10:29 -0400, Frank Ch. Eigler wrote:

> > > That, plus the new hand-written function (trace_futex_wait) would
> > > still need to manage the packaging of the arguments for consumption by
> > > separately compiled pieces.  It is desirable not to require such
> > > hand-written functions to *also* be declared in headers for these
> > > event consumers to compile against.
> 
> > *blink* so all this is so you don't have to put a declarion in a
> > header file? How about we put these premanent markers in a header -
> > Mathieu says there are <200. Surely that's not too much trouble.
> > [...]
> 
> It's not just that - it's a whole package including easy creation of
> new markers, the code that manages their activation and deactivation,
> the tool code that connects up to receive new events *and parameters*.
> The current approach does not require tight compilation-level
> coupling.  Indeed, for a new marker, the current approach requires
> *no* code changes to anywhere other than the one-line inserted marker,
> for tools like systemtap to connect and use them.  Cool eh?


I'm thinking the two use-cases are confused here. So we have

 a) permanent markers
 b) ad-hoc debug markers

I'm thinking that for the first class the compilation level coupling is
no problem at all. And for the second class it doesn't matter how ugly
they are as long as it works on the spot.

So I'm arguing these two should be separated.

