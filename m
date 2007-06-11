Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbXFKVt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbXFKVt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXFKVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:49:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33513 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXFKVtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:49:49 -0400
Date: Mon, 11 Jun 2007 23:50:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kbuild: fix section mismatch check for vmlinux
Message-ID: <20070611215052.GA8132@uranus.ravnborg.org>
References: <466D2337.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466D2337.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 10:25:59AM +0200, Jan Beulich wrote:
> >vmlinux does not contain relocation entries which is
> >used by the section mismatch checks.
> >Reported by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> >
> >Use the individual objects as inputs to overcome
> >this limitation.
> >In modpost check the .o files and skip non-ELF files.
> >
> >Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> This still doesn't appear to catch all cases - since the checking logic works
> on a per-module basis, references between the individual .o files aren't
> being checked. A current instance where this is visible is x86-64's recently
> added alloc_bootmem_high_node (non-__init, in arch/x86_64/mm/built-in.o)
> calling __alloc_bootmem_core (__init, in mm/built-in.o). I suppose there's
> no way around linking $(KBUILD_VMLINUX_OBJS) into vmlinux.o, and
> checking that file instead.

It is planned to do something around these lines.
Today we do a lot of linking in the final stages and the Makefile
magic involved is starting to make my head spinning.
So my plan is to redo all the "link vmlinux" stuff and
locate it in the top-level Kbuild file.
As part of this process I would then create vmlinux.o as one
of the steps - it will have all sections intact and allow
for a full modpost run.

We would then lack the hint about what subsystem caused the
warning bot most often a "git grep" tells me that in less than 10
seconds anyway.

The extra link step would also benefit kallsyms check I think so
it will not be waste of time.

But summer has hit us so it may be after next merge window.
The changes would anyway need to cook in -mm a while before
I would push them to mainstream.

	Sam
