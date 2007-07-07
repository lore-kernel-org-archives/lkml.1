Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbXGGAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbXGGAJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXGGAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:09:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:54847 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752488AbXGGAJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:09:02 -0400
Date: Sat, 7 Jul 2007 02:13:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <468D5B28.8080308@redhat.com>
Message-ID: <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
 <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
 <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
 <20070522161642.b71ddacb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com>
 <468D5B28.8080308@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Rik van Riel wrote:

> So the original patch has:
> #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
> For some reason(?) it got changed to the clearly buggy:
> #define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
> Jiri's patch undoes that second buggy define, which is very
> different from the original that was sent in by you and Ernie.

This is a part of execshield patch, fthe pie-compiled binary executable 
memory layout randomization was extracted from - see 
http://people.redhat.com/~mingo/exec-shield/exec-shield-nx-2.6.19.patch

Note that load_elf_interp() in vanilla kernel differs from the 
execshield's (and pie-randomization.patch) version.

The fix makes the BAD_ADDR check whether the address belongs to the 
ERR_PTR range, which seems valid for all uses of BAD_ADDR in the patched 
binfmt_elf.c (do_brk(), elf_map(), do_mmap() etc return valid address or 
err ptr) ... am I missing something obvious here?

-- 
Jiri Kosina
SUSE Labs
