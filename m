Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYAIWjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYAIWjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYAIWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:39:11 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48515 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYAIWjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:39:09 -0500
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
From: Jim Keniston <jkenisto@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, mingo@elte.hu, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
In-Reply-To: <20080109212103.GB15612@one.firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com>
	 <p73zlvgowwn.fsf@bingen.suse.de>
	 <1199833842.3914.33.camel@dyn9047018096.beaverton.ibm.com>
	 <20080108232841.GD2117@one.firstfloor.org>
	 <1199910240.4162.31.camel@dyn9047018096.beaverton.ibm.com>
	 <20080109212103.GB15612@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 14:33:58 -0800
Message-Id: <1199918039.4162.40.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 22:21 +0100, Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 12:24:00PM -0800, Jim Keniston wrote:
> > On Wed, 2008-01-09 at 00:28 +0100, Andi Kleen wrote:
> > > > I have no problem with that, but if we want to make it buildable as a
> > > > module, the call to get_kprobe() needs to be replaced with some other
> > > > gcc-inline-defeating mechanism, or we need to export get_probe().  I
> > > 
> > > It's still unclear where noinline does not work (do you have details on that? 
> > > It sounds a little dubious) ...
> > 
> > Here's a simplified version of a module we've used to gauge kprobes
> > performance.  On my system (i386, 2.6.23-rc8 at the moment, gcc version
> > 4.1.2), the module calls the (empty) probed function (probeme) niter
> > times, but reports zero probe hits -- indicating probeme was inlined
> > even though it was declared noinline.
> 
> Yes indeed looks like a gcc bug. Have you reported it?
> 
> -Andi

There's already a gcc bug report that appears to describe the same
problem:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34563
There seems to be some doubt as to whether it's really a bug, so I added
my 2 cents, including a pointer to this thread.

Jim 

