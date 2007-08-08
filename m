Return-Path: <linux-kernel-owner+w=401wt.eu-S936997AbXHHBZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936997AbXHHBZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937079AbXHHBXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:23:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58873 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936615AbXHHBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:23:45 -0400
Date: Wed, 8 Aug 2007 02:31:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [RFC][PATCH 1/5] pagemap: remove file header
Message-ID: <20070808023100.222c4d15@the-village.bc.nu>
In-Reply-To: <20070808011620.GF30556@waste.org>
References: <20070807223300.9228E0E0@kernel>
	<20070808011620.GF30556@waste.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> > The endianness is only useful when examining a raw dump of
> > pagemap from a different machine when you don't know the
> > source of the file.  This is pretty rare, and the programs
> > or scripts doing the copying off-machine can certainly be
> > made to hold this information.

Nobody fancies doing bi-endian MIPS ?

> > The page size is available in userspace at least with libc's
> > getpagesize().  This will also never vary across processes,

For now. Its a logical direction however thant we end up with bigger page
sizes either by hardware or by software merging and end up having
different page sizes for legacy 32bit binaries.

> I'd really strongly prefer to have no header. It was added to
> futureproof the thing.

The information needed to parse /proc/pid/pagemap can be stuck
in /proc/pid/somewherelese. If we ever get page size variations and the
like then /proc/pid/ is going to end up with that information anyway for
ps and friends to use.

