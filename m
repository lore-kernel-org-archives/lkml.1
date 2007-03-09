Return-Path: <linux-kernel-owner+w=401wt.eu-S1767398AbXCIQtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767398AbXCIQtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767400AbXCIQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:49:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:34583 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767398AbXCIQtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:49:47 -0500
Subject: Re: [PATCH] Complain about missing system calls.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, rmk@arm.linux.org.uk
In-Reply-To: <p737itqbdnl.fsf@bingen.suse.de>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <p737itqbdnl.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 17:47:34 +0100
Message-Id: <1173458854.24454.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 17:11 +0100, Andi Kleen wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> 
> > Most system calls seem to get added to i386 first. This patch
> > automatically generates a warning for any new system call which is
> > implemented on i386 but not the architecture currently being compiled.
> > On PowerPC at the moment, for example, it results in these warnings:
> > init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
> > init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> > init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
> 
> I think a better solution would be to finally switch to auto generated
> system call tables for newer system calls. The original reason why the
> architectures have different system call numbers -- compatibility with
> another "native" Unix -- is completely obsolete now. This leaves only
> minor differences of compat stub vs non compat stub and a few
> architecture specific calls.
> 
> Of course the existing syscall numbers can't be changed, but for all new 
> calls one could just add automatically for everybody.
> 
> A global table with two entries (compat and non compat) and a per arch 
> override table should be sufficient.

We need additional gunk for syscalls that can be called from SPEs on
cell

Ben.


