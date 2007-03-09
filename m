Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXCIPMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXCIPMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992840AbXCIPMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:12:13 -0500
Received: from mail.suse.de ([195.135.220.2]:52324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992835AbXCIPML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:12:11 -0500
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Complain about missing system calls.
References: <1173394873.3461.510.camel@pmac.infradead.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2007 17:11:10 +0100
In-Reply-To: <1173394873.3461.510.camel@pmac.infradead.org>
Message-ID: <p737itqbdnl.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> Most system calls seem to get added to i386 first. This patch
> automatically generates a warning for any new system call which is
> implemented on i386 but not the architecture currently being compiled.
> On PowerPC at the moment, for example, it results in these warnings:
> init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
> init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented

I think a better solution would be to finally switch to auto generated
system call tables for newer system calls. The original reason why the
architectures have different system call numbers -- compatibility with
another "native" Unix -- is completely obsolete now. This leaves only
minor differences of compat stub vs non compat stub and a few
architecture specific calls.

Of course the existing syscall numbers can't be changed, but for all new 
calls one could just add automatically for everybody.

A global table with two entries (compat and non compat) and a per arch 
override table should be sufficient.

Comments?

-Andi
