Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXC3FKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXC3FKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXC3FKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:10:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41701 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbXC3FKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:10:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
	<20070329142816.5d18d89f.akpm@linux-foundation.org>
	<m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
	<20070329152317.56df80d0.akpm@linux-foundation.org>
Date: Thu, 29 Mar 2007 23:10:20 -0600
In-Reply-To: <20070329152317.56df80d0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 29 Mar 2007 15:23:17 -0700")
Message-ID: <m14po3jozn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>
> config PROC_SYSCTL
>         bool "Sysctl support (/proc/sys)" if EMBEDDED
>         depends on PROC_FS
>         select SYSCTL
>         default y
>
> CONFIG_PROC_SYSCTL depends on CONFIG_PROC_FS
> CONFIG_PROC_SYSCTL selects CONFIG_SYSCTL
>
> So I don't see anything preventing CONFIG_SYSCTL=y, CONFIG_PROC_FS=y,
> CONFIG_PROC_SYSCTL=n.  I assume we can make this combination compile, link
> and run easily enough.  I dunno if it makes any actual sense though?
>
>
> I'd have thought that PROC_SYSCTL should just depend on SYSCTL.  But
> SYSCTL's Kconfig setup is weird.

Yes. My memory is now coming back.  I did a few weird things in there 
when I was making the binary interface optional, and it looks like
I never updated the #ifdef in fs/proc/root.c  The primary intent
was to allow the proc support without the binary interface but I
guess the other configuration makes some sense as well in an embedded
scenario when you are trying to be as efficient as possible.  As I
recall the binary interface is less resource intensive then the /proc
interface.

Eric

