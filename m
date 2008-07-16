Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYGPK6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYGPK6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYGPK6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:58:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYGPK6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:58:12 -0400
Date: Wed, 16 Jul 2008 06:56:44 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080716105644.GB5413@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain> <y0mr69vj5p0.fsf@ton.toronto.redhat.com> <1216151526.3312.102.camel@localhost.localdomain> <20080715200718.GC4280@redhat.com> <1216153462.3312.126.camel@localhost.localdomain> <20080715221826.GD4280@redhat.com> <1216173983.3312.183.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216173983.3312.183.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 15, 2008 at 09:06:23PM -0500, James Bottomley wrote:
> [...]
> > Please choose your words more carefully.  We don't "subvert" anything,
> > where one would mean sneaking around some sort of protection.
> 
> Actually, I did and you do.  One of the OED's definition of subvert is
> "to undermine or overturn a condition or order of things, a principle or
> a law etc."  In this particular case, this:
> 
> commit 3a872d89baae821a0f6e2c1055d4b47650661137
> Author: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Date:   Mon Oct 2 02:17:30 2006 -0700
>     [PATCH] Kprobes: Make kprobe modules more portable
>
> Which provided a portable input to kprobes (the symbol_name/offset one)
> and revoked the global accessibility of the kallsyms_lookup_name().

That patch served two purposes: a helpful utility for other kprobes
users, and it enabling what LKML deemed more important - unexporting
kallsyms*.


> It's actually worse than this, though.  The kernel API isn't fixed in
> stone, it evolves usually by trying to make problematic use cases
> better.  By refusing to consider using the replacement API [...]

Your lecture is based upon a misundertanding ...


> [...]
> It emits a single probe and produces this in the module build:
> -rw-r--r-- 1 root root  17996 2008-07-15 20:45 stap_2154.c
> About 600 lines.
> However, it also needs this for the symbol table:
> -rw-r--r-- 1 root root 446137 2008-07-15 20:45 stap-symbols.h

... that this is somehow connected to the kprobe api issue.

IT IS NOT.

We do not use those symbol tables for kprobe placement purposes.
(This part is partially a prototype for user-space parts, and the
sizes will not stay large.)

The way we set up kprobes now could be trivially converted to
"_stext"+offset.  Would that alone allay your concerns?


- FChE
