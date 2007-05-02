Return-Path: <linux-kernel-owner+w=401wt.eu-S2992855AbXEBHwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992855AbXEBHwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992876AbXEBHwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:52:11 -0400
Received: from ozlabs.org ([203.10.76.45]:45756 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992855AbXEBHwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:52:09 -0400
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
	 <1178084403.28659.222.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
	 <1178087393.28659.238.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
	 <1178089444.28659.246.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 17:51:55 +1000
Message-Id: <1178092315.28659.255.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 00:22 -0700, David Rientjes wrote:
> On Wed, 2 May 2007, Rusty Russell wrote:
> 
> > 	That sounds exactly right to me!  If the author says it's optional, it
> > might be discarded.  If they say it's needed, it won't be.  At least,
> > when I'm coding and gcc warns me something is unused, this is the
> > decision I have to make ("is this really needed or not?").
> > 
> 
> Hi Rusty,
> 
> There are many instances in the tree of functions that have no callers 
> whatsoever because they've been commented out temporarily, disabled 
> through configuration, etc.  These are marked __attribute__ ((unused)) 
> right now so that the compiler doesn't emit a warning (and with gcc >=3.4 
> it doesn't even emit code for them).  What's __optional about these 
> functions if they have no callers?  They're unused.  So we cover all our 
> bases with __maybe_unused.

Hi David,

	If they're really unused, they should be deleted, not
warning-suppressed.  The interesting case is where they may or may not
be used because of config options.  ie. they're optional.

	__maybe_unused does not, at a glance, tell me that it's OK for gcc to
drop them.  __optional comes closer.  However, it's better than
__unused, so I'll stop now 8)

Thanks,
Rusty.

