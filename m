Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbXLMRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbXLMRB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764207AbXLMQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:58:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46942 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764181AbXLMQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:58:45 -0500
Date: Thu, 13 Dec 2007 16:52:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Ben Collins <ben.collins@ubuntu.com>
Subject: Re: Providing an ELF flag for disabling LD_PRELOAD/ptrace()
Message-ID: <20071213165245.6132529f@the-village.bc.nu>
In-Reply-To: <20071213162448.GG6173@piware.de>
References: <20071213162448.GG6173@piware.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> one thing that has bothered me for a long time already is the
> complete lack of a security boundary between processes of the same
> user. Things like LD_PRELOAD and ptrace() (IOW, gdb) are enabled by
> default for all users, and especially for developers this is a good
> thing.

This is the normal Unix model.

> What I want is the behaviour of suid/sgid executables (which do
> something like an atomic prctl(PR_SET_DUMPABLE, 0) to disable vectors
> like ptrace(), LD_PRELOAD, etc. However, making binaries setugid just
> for that is less than ideal, since it requires a lot of code patching
> (to reset the group) and packaging changes (to maintain the
> sgid setting), as well as confusing security scanners, etc.

This is an SELinux problem. In fact this kind of compartmentalisation is
exactly what SELinux is designed to provide.

> So I wonder whether we can define a flag in the ELF header which
> triggers the same behaviour? Can we define an e_flags bit for that?

If it were just ptrace it would be trivial, but its naiive to think that
is the case. Constraining things while not entirely compartmentalising is
a good thing, and policykit is the right path, but the security
components that are needed seem to already exist in SELinux and little ELF
binary header hacks don't do the job properly.

Alan
