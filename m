Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbXLUX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbXLUX2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXLUX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:28:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbXLUX2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:28:25 -0500
Date: Fri, 21 Dec 2007 15:27:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: clameter@sgi.com, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       rjw@sisk.pl
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-Id: <20071221152736.7f9637a9.akpm@linux-foundation.org>
In-Reply-To: <20071221225413.GA26189@elte.hu>
References: <20071211143336.GA17866@elte.hu>
	<Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	<20071221120908.GA15926@elte.hu>
	<Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	<alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	<Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	<1198275391.30889.3.camel@lappy>
	<1198275453.30889.4.camel@lappy>
	<Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	<20071221225413.GA26189@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 23:54:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Fri, 21 Dec 2007, Peter Zijlstra wrote:
> > 
> > > BTW, does /proc/slabinfo exist again? I thought we set that as a 
> > > requirement for SLUB to be the default and a full replacement for 
> > > SLAB.
> > 
> > Well the information that would be exposed in /proc/slabinfo would 
> > only be faked up stuff from SLUB. The queues that are described in 
> > /proc/slabinfo do not exist f.e. (tunables do not make sense) and 
> > there are more details available via /sys/kernel/slab.
> 
> Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it.

That would be really bad.

/proc/slabinfo intimately exposes implementation-specific internals and
strictly speaking should never have been introduced.  Obviously that isn't
a _practical_ position, but there are no easy solutions here.

We don't want to have to drag a pile of be-compatible-with-slab gunk along
with us for ever.

> slabtop 
> relies on it, people use it every day to monitor memory consumption.

slabtop needs to be changed asap.

Possibly we could look at adding some interrim make-it-look-like-slab hack
into slub.c for a couple of releases but no longer.

If we'd updated slabtop six months ago this issue wouldn't have arisen now.

But we didn't do that.   We're quite bad at this sort of thing.
