Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYBRNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYBRNMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYBRNMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:12:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:33270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbYBRNME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:12:04 -0500
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
From: Andi Kleen <andi@firstfloor.org>
References: <20080207230304.GA4352@ghostprotocols.net>
Date: Mon, 18 Feb 2008 14:12:01 +0100
In-Reply-To: <20080207230304.GA4352@ghostprotocols.net> (Arnaldo Carvalho de Melo's message of "Thu\, 7 Feb 2008 21\:03\:04 -0200")
Message-ID: <p73ir0mxvby.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@redhat.com> writes:
>
> [acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
> -rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
> -rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before
>
> 	Almost 64KB only on this object file!

Just FYI, newer gcc does this in theory automatically when you specify 

-feliminate-unused-debug-types -feliminate-unused-debug-symbols

But in my tests on gcc 4.1 / gcc 4.2 it doesn't seem to make any difference
currently :/ Not sure what is wrong. 

There is also -feliminate-dwarf2-dups, but it seems to even increase
obj dir size. Also -feliminate-dwarf2-dups seems to generate a lot of 

WARNING: vmlinux.o (.gnu.linkonce.wi.mmzone.h.97561702): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

etc. warnings But the kernel builds fine even with those warnings.

Still if you just want to shrink objdir size then figuring out
what's wrong with these options and then specifying them would be 
probably the best strategy than to try to do it all manually.

That said removing unused includes is of course a valuable
clean up by itself, I'm just not sure it's the best way to get
smaller object dirs.

-Andi

