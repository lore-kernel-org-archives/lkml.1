Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbYGPO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbYGPO4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYGPO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:56:09 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36886 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbYGPO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:56:07 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080716105644.GB5413@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain>
	 <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
	 <1216151526.3312.102.camel@localhost.localdomain>
	 <20080715200718.GC4280@redhat.com>
	 <1216153462.3312.126.camel@localhost.localdomain>
	 <20080715221826.GD4280@redhat.com>
	 <1216173983.3312.183.camel@localhost.localdomain>
	 <20080716105644.GB5413@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 09:56:02 -0500
Message-Id: <1216220162.3358.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 06:56 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Jul 15, 2008 at 09:06:23PM -0500, James Bottomley wrote:
> > [...]
> > > Please choose your words more carefully.  We don't "subvert" anything,
> > > where one would mean sneaking around some sort of protection.
> > 
> > Actually, I did and you do.  One of the OED's definition of subvert is
> > "to undermine or overturn a condition or order of things, a principle or
> > a law etc."  In this particular case, this:
> > 
> > commit 3a872d89baae821a0f6e2c1055d4b47650661137
> > Author: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > Date:   Mon Oct 2 02:17:30 2006 -0700
> >     [PATCH] Kprobes: Make kprobe modules more portable
> >
> > Which provided a portable input to kprobes (the symbol_name/offset one)
> > and revoked the global accessibility of the kallsyms_lookup_name().
> 
> That patch served two purposes: a helpful utility for other kprobes
> users, and it enabling what LKML deemed more important - unexporting
> kallsyms*.
> 
> 
> > It's actually worse than this, though.  The kernel API isn't fixed in
> > stone, it evolves usually by trying to make problematic use cases
> > better.  By refusing to consider using the replacement API [...]
> 
> Your lecture is based upon a misundertanding ...
> 
> 
> > [...]
> > It emits a single probe and produces this in the module build:
> > -rw-r--r-- 1 root root  17996 2008-07-15 20:45 stap_2154.c
> > About 600 lines.
> > However, it also needs this for the symbol table:
> > -rw-r--r-- 1 root root 446137 2008-07-15 20:45 stap-symbols.h
> 
> ... that this is somehow connected to the kprobe api issue.
> 
> IT IS NOT.
> 
> We do not use those symbol tables for kprobe placement purposes.
> (This part is partially a prototype for user-space parts, and the
> sizes will not stay large.)

There's no misunderstanding that you're currently embedding the kernel
symbol table and have expanded the sizes of the modules enormously to do
so.  The real truth is that coming up with convoluted ways to recompute
some information the kernel already knows is fragile and shouldn't be
done.  What should be done is to engage in discussion about how to get
that information out of the kernel ... preferably with use cases and
patches.

> The way we set up kprobes now could be trivially converted to
> "_stext"+offset.  Would that alone allay your concerns?

No ... because as I already said, that's broken for -ffunction-sections.
It needs to be the symbol of the actual function the probe is in and the
offset into that function.

James


