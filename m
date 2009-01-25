Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZAYPxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZAYPxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZAYPwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:52:54 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:63851 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbZAYPwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:52:53 -0500
Subject: Re: [PATCH] module: kzalloc mod->ref
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@infradead.org>, Takashi Iwai <tiwai@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200901151303.20006.rusty@rustcorp.com.au>
References: <20090114033533.GL25103@bombadil.infradead.org>
	 <496E261F.9000803@rsk.demon.co.uk>
	 <20090114181748.GQ25103@bombadil.infradead.org>
	 <200901151303.20006.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 15:52:51 +0000
Message-Id: <1232898771.3658.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 13:03 +1030, Rusty Russell wrote:
>  
> 
> On Thursday 15 January 2009 04:47:48 Kyle McMartin wrote:
> 
> > On Wed, Jan 14, 2009 at 05:51:27PM +0000, richard kennedy wrote:
> 
> > > Aside from the code in socket does this reference count really get
> used
> 
> > > that often? Atomic_t gets used for ref counts is lots of other
> places in
> 
> > > the kernel, so why not turn module_ref into an atomic counter &
> drop the
> 
> > > array entirely saving all of the memory & disk space?
> 
> The code was originally written with the intent that networking would
> inc and dec a module count on every *packet*. It doesn't, however
> (though it would be interesting to instrument who does manip it, and
> how often).
> 
> I suspect that we could get away with an atomic_t and noone would
> notice, but I'd like to see evidence one way or the other.
> 
> Cheers,
> 
> Rusty.
Hi Rusty,
I've been running module reference counts as atomic_t on my desktop
(x86_64 AMD X2) all week and haven't been able to measure any
significant performance differences. I guess more cpus & server
workloads could show up something, but I don't have access to that sort
of hardware.

The one issue I am seeing is with my simple test harness, which is just
a very basic socket client/server. With the existing ref counting code,
when running several copies of the client I sometimes get EADDRNOTAVAIL
(-99) errors on socket connect(). But I don't see any errors with the
atomic_t ref counting. 
I'm still trying to debug this, but I haven't yet found where in the
network stack these errors are coming from. 

regards
Richard




