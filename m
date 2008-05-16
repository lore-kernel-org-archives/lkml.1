Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYEPLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYEPLWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYEPLWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:22:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYEPLWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:22:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080516090150.GA16496@linux-sh.org>
References: <20080516090150.GA16496@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: Magical stack pointer index, for NEW_AUX_ENT compat.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 16 May 2008 12:22:33 +0100
Message-ID: <12478.1210936953@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> While implementing binfmt_elf_fdpic on SH it quickly became apparent
> that SH was the first platform to support both binfmt_elf_fdpic and
> binfmt_elf, as well as the only of the FDPIC platforms to make use of the
> auxvt.
> 
> Currently binfmt_elf_fdpic uses a special version of NEW_AUX_ENT() where
> the first argument is the entry displacement after csp has been adjusted,
> being reset after each adjustment. As we have no ability to sort this out
> through the platform's ARCH_DLINFO, this index needs to be managed
> entirely in create_elf_fdpic_tables(). Presently none of the platforms
> that set their own auxvt entries are able to do so through their
> respective ARCH_DLINFOs when using binfmt_elf_fdpic.
> 
> In addition to this, binfmt_elf_fdpic has been looking at
> DLINFO_ARCH_ITEMS for the number of architecture-specific entries in the
> auxvt. This is legacy cruft, and is not defined by any platforms in-tree,
> even those that make heavy use of the auxvt. AT_VECTOR_SIZE_ARCH is
> always available, and contains the number that is of interest here, so we
> switch to using that unconditionally as well.
> 
> As this has direct bearing on how much stack is used, platforms that have
> configurable (or dynamically adjustable) NEW_AUX_ENT calls need to either
> make AT_VECTOR_SIZE_ARCH more fine-grained, or leave it as a worst-case
> and live with some lost stack space if those entries aren't pushed (some
> platforms may also need to purposely sacrifice some space here for
> alignment considerations, as noted in the code -- although not an issue
> for any FDPIC-capable platform today).
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: David Howells <dhowells@redhat.com>
