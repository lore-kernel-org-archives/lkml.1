Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYBMMtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYBMMtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYBMMtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:49:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYBMMtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:49:41 -0500
Date: Wed, 13 Feb 2008 07:49:27 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: asm-x86/sigcontext.h changes break userland
Message-ID: <20080213124926.GM24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080213001532.GJ24887@devserv.devel.redhat.com> <20080213072650.GA4363@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213072650.GA4363@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:26:50AM +0100, Ingo Molnar wrote:
> 
> * Jakub Jelinek <jakub@redhat.com> wrote:
> 
> > x86: use generic register names in struct sigcontext 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=742fa54a62be6a263df14a553bf832724471dfbe
> > 
> > changeset breaks userland, e.g. it is not possible to compile gcc 
> > anymore (both 32-bit and 64-bit libgcc), and I expect any other 
> > program which pokes into struct sigcontext.  The register names with e 
> > resp. r have been in use for years, what's the point breaking it now?
> 
> ok - does the patch below solve the problem for you?

Yes, this fixes it.  Thanks.

FYI, gcc uses glibc headers to get at struct sigcontext, but
on i386 (and many other arches) glibc's <bits/sigcontext.h> just includes
<asm/sigcontext.h>.  On x86_64, ia64 and sparc* glibc doesn't include
asm/sigcontext.h, but provides its own definitions, so for gcc itself
only changing 32-bit parts woiuld be enough.  That said, there are certainly
programs which include asm/sigcontext.h directly (plus there are other c
libraries, some of which may use asm/sigcontext.h).

	Jakub
