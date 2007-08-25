Return-Path: <linux-kernel-owner+w=401wt.eu-S965019AbXHYMIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbXHYMIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 08:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXHYMIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 08:08:15 -0400
Received: from ozlabs.org ([203.10.76.45]:54746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXHYMIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 08:08:14 -0400
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, kraxel@redhat.com
In-Reply-To: <20070824082249.GG31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
Content-Type: text/plain
Date: Sat, 25 Aug 2007 22:07:29 +1000
Message-Id: <1188043649.20041.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 10:22 +0200, Frederik Deweerdt wrote:
> [Added Gerd Hoffman and Rusty Russel to cc]
> On Thu, Aug 23, 2007 at 11:46:52PM -0700, Jeremy Fitzhardinge wrote:
> > Frederik Deweerdt wrote:
> > > That means that even when you specify noreplace_smp, some replacing
> > > takes place anyway. One of the consequences, besides noreplace_smp not
> > > working as expected, is that lguest crashes when you feed it an SMP kernel
> > > (I suspect that you can not replace alternatives for smp _and_ paravirt).
> > >   
> > 
> > No, that should be fine.  Why does lguest crash?
> It dies with:
> [    0.131000] SMP alternatives: switching to UP code
> lguest: bad stack page 0xc057a000

How odd!  This means that the guest set the kernel to a stack which it
hadn't mapped writable (or perhaps not mapped at all).  I always run SMP
kernels, and that seems a very strange side effect of a patching
problem...

Nonetheless, I did have a previous problem with a bug in the patching
code which didn't show up native and did show up under lguest.

Can you send your config?  Do you need noreplace-smp even on 2.6.23-rc3,
or only 2.6.23-rc3-mm1?

Thanks,
Rusty.


