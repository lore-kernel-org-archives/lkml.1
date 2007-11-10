Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbXKJUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbXKJUKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXKJUJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:09:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52465 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753843AbXKJUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:09:58 -0500
Date: Sat, 10 Nov 2007 20:09:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-ID: <20071110200935.60d375de@the-village.bc.nu>
In-Reply-To: <24343.1194697130@redhat.com>
References: <20071109195303.edbdc631.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
	<24343.1194697130@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The vast majority of which are either memory-mapped hardware registers or
> interrupt-routine-filled ring buffers.

memory mapped registers should be read with readw and friends and that
should contain the volatile not the public code.

Similarly spin_lock/unlock are store barriers so for ring buffers should
be sufficient unless you have cache management requirements in which case
the dma_* APIs will handle those bits.

Knocking these sort of things on the head does want doing, we are still
having to clean up ancient drivers/platforms that don't do this and
frequently break as a result.

> | WARNING: do not add new typedefs
> | #27265: FILE: include/asm-mn10300/types.h:30:
> | +typedef unsigned int __u32;
> 
> Pah!

Send bugs to the maintainer. You've triggered a new case - adding an arch
and it gets the wrong idea.

> 
> | #29191: FILE: include/asm-mn10300/user.h:50:
> | +#define HOST_TEXT_START_ADDR +(u.start_code)
> |                               ^
> |
> | ERROR: need consistent spacing around '+' (ctx:WxV)
> 
> Doesn't checkpatch know a unary plus when it sees one?

No - its rather dumb on rule handling and will need a rewrite someday to
handle typedefs as well.

> 	#1269: FILE: arch/mn10300/boot/compressed/head.S:38:
> 
> Should be:
> 
> 	arch/mn10300/boot/compressed/head.S:38:
> 
> Yes, I know there's a --emacs flag, but that only affects references into the
> patch, not references into the files the patch refers to.

Send patches...

Alan
