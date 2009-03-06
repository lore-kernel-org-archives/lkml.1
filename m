Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZCFTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZCFTbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZCFTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:31:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579AbZCFTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:31:26 -0500
Date: Fri, 6 Mar 2009 11:30:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce bootmem_state -v2
Message-Id: <20090306113054.4ae4b875.akpm@linux-foundation.org>
In-Reply-To: <20090306191249.GC28582@elte.hu>
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi>
	<49B02498.9080300@kernel.org>
	<49B02C68.1030203@cs.helsinki.fi>
	<49B0640A.5080607@kernel.org>
	<20090306145928.GE21907@elte.hu>
	<49B16DA6.4090108@kernel.org>
	<20090306191249.GC28582@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 20:12:49 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > Impact: cleanup
> > 
> > extend after_bootmem and after_init_bootmem to bootmem_state
> > and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
> > 
> > v2: style changes according to ingo
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/kernel/setup.c |    1 +
> >  arch/x86/mm/init.c      |   13 +++++++------
> >  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
> >  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
> >  include/linux/mm.h      |    9 +++++++++
> >  5 files changed, 56 insertions(+), 28 deletions(-)
> 
> > Index: linux-2.6/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm.h
> > +++ linux-2.6/include/linux/mm.h
> > @@ -1067,6 +1067,15 @@ extern void __init mmap_init(void);
> >  extern void show_mem(void);
> >  extern void si_meminfo(struct sysinfo * val);
> >  extern void si_meminfo_node(struct sysinfo *val, int nid);
> > +
> > +enum bootmem_state {
> > +	BEFORE_BOOTMEM,
> > +	DURING_BOOTMEM,
> > +	AFTER_BOOTMEM
> > +};
> > +
> > +extern enum bootmem_state bootmem_state;
> > +
> >  extern int after_bootmem;
> 
> Btw., the after_bootmem variable itself should either move to 
> x86 (and arch/sh), or should be defined in mm/bootmem.c.
> 
> Right now we have this weird mm.h construct that is not actually 
> useful to generic code.
> 
> Andrew, what would be your preference?
> 

If two architectures are using it then it should be provided by core
kernel?

This is obvious if the state transitions are occurring in core-kernel
code, but if the transitions are happening in arch code then making it
a core concept assumes consistency between different architectures
which might not exist.

IOW: dunno.
