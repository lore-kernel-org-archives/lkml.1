Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZEMFgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZEMFgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZEMFgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:36:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53165 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZEMFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:36:45 -0400
Date: Wed, 13 May 2009 06:36:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090513053622.GQ8633@ZenIV.linux.org.uk>
References: <20090508184838.GA11157@havoc.gtf.org> <200905122304.52395.rusty@rustcorp.com.au> <20090512140344.GO8633@ZenIV.linux.org.uk> <200905131142.27484.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905131142.27484.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 11:42:26AM +0930, Rusty Russell wrote:
> > > Anyway, since [] is C99, I thought it preferable to [0] which is a gcc
> > > extension.  However, if C99 is really so braindead as to disallow this
> > > fairly standard trick, so I'm happy to go with the gcc extension.[1]
> >
> > No.  There's a standard way to do that in C99; you can put a struct with
> > that thing into a union.
> 
> Ah, thanks for the clue.
> 
> How's this:
> 
> sched: avoid flexible array member inside struct (gcc extension)
> 
> struct sched_group and struct sched_domain end in 'unsigned long
> cpumask[]' which Jeff Garzik notes is not legal to place inside
> another struct.  It upsets sparse and clang (LLVM's C front end).
> 
> Al Viro pointed out that a union is the Right Way to do this.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
