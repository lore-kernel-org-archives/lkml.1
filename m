Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYEGD1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYEGD1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEGD10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:27:26 -0400
Received: from [198.99.130.12] ([198.99.130.12]:44552 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYEGD1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:27:25 -0400
Date: Tue, 6 May 2008 23:26:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] fix UML on x86-64
Message-ID: <20080507032611.GA15155@c2.user-mode-linux.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org> <4820EC0E.1030603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4820EC0E.1030603@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 04:38:54PM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > It breaks things how?
> 
> A crash on startup:

It seems that initcalls from the libc side of the house aren't being
called because they're not in the initcall section.  The one that
matters here is init_syscall_regs in arch/um/os-Linux/skas/mem.c.  If
you run with initcall_debug, you'll notice its absence.  As to why,
and why it depends on -fno-unit-at-a-time, I have no idea.

    	   	   Jeff

-- 
Work email - jdike at linux dot intel dot com
