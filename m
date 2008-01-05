Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYAEAcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYAEAcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYAEAcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:32:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYAEAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:32:04 -0500
Date: Fri, 4 Jan 2008 16:27:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] slub: provide /proc/slabinfo
Message-ID: <20080104162705.44b61e9a@laptopd505.fenrus.org>
In-Reply-To: <20080101162328.GC20426@elte.hu>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
	<20071222221050.GA20753@1wt.eu>
	<Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
	<20071223051241.GA4449@1wt.eu>
	<20071223141500.GB6430@one.firstfloor.org>
	<20071224034530.GB16658@thunk.org>
	<Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
	<20071224233701.GB9784@kernel.org>
	<20071225033418.GA29199@one.firstfloor.org>
	<20080101124741.GH11776@mit.edu>
	<20080101162328.GC20426@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 17:23:28 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
> > [...] doesn't a patch to provide /proc/slabinfo for SLUB already 
> > exist?
> 
> yes, the complete (and tested) patch is below. It has been through a
> few thousand random-bootup tests on x86 32-bit and 64-bit so it's
> v2.6.24 material i think.


> +static void *s_start(struct seq_file *m, loff_t *pos)
> +{
> +	loff_t n = *pos;
> +
> +	down_read(&slub_lock);
> +	if (!n)
> +		print_slabinfo_header(m);
> +
> +	return seq_list_start(&slab_caches, *pos);
> +}
> +


this is the part I'm not very thrilled about... at least on first sight
it looks like a user can now hold the read sem over system calls, and for as long as it wants.
Either that's no problem (but then we wouldn't need the lock in the first place) or it
is a problem that then wants to be fixed
