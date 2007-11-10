Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXKJMTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXKJMTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 07:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXKJMS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 07:18:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXKJMSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 07:18:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071109195303.edbdc631.akpm@linux-foundation.org>
References: <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 10 Nov 2007 12:18:50 +0000
Message-ID: <24343.1194697130@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> ho hum, I've seen worse-looking code ;).  There's quite a bit of the usual
> stuff in there: use of SPIN_LOCK_UNLOCKED, a forest of fishy-looking
> volatiles

The vast majority of which are either memory-mapped hardware registers or
interrupt-routine-filled ring buffers.

> but I don't need to sit here and emulate checkpatch.pl.

No, it should be deleted:

	shred -fu scripts/checkpatch.pl

will do the trick quite nicely.

| WARNING: do not add new typedefs
| #27265: FILE: include/asm-mn10300/types.h:30:
| +typedef unsigned int __u32;

Pah!

| #29191: FILE: include/asm-mn10300/user.h:50:
| +#define HOST_TEXT_START_ADDR +(u.start_code)
|                               ^
|
| ERROR: need consistent spacing around '+' (ctx:WxV)

Doesn't checkpatch know a unary plus when it sees one?

In this particular case this is so this macro can be used in assembly without
causing problems there.  Without the plus, the assembler thinks it has to
treat the (xxx) as a memory access, with the plus it thinks +(xxx) is an
immediate operand.  Unfortunately, whoever set up MN10300 assembly didn't
include an immediate-operand marker.


Furthermore, the program also puts out the line references for its error
messages in a non-standard format, thus preventing things like emacs's
compilation mode from being able to step through them.

	#1269: FILE: arch/mn10300/boot/compressed/head.S:38:

Should be:

	arch/mn10300/boot/compressed/head.S:38:

Yes, I know there's a --emacs flag, but that only affects references into the
patch, not references into the files the patch refers to.

> I googled a bit but most of the mn10300 info pertains to linux kernel and
> gcc.  Who is using this CPU and in what applications?

This CPU is MEI/Matsushita/Panasonic's own CPU.  If you've bought a Panasonic
telly, say, in the last few years, the odds are rather good that it's got one
of these CPUs in it running Linux.

	http://www.am-linux.jp/

has a couple of examples on it's front page.  If you work through the menus of
modern Panasonic tellies, you might find a URL pointing somewhere on this
website that isn't reachable by linking from the index page of the website.

I don't know who else uses this CPU, but it's possible MEI sell them to other
companies.

David
