Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbXCPN4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbXCPN4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXCPN4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:56:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52259 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933800AbXCPNz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:55:59 -0400
Date: Fri, 16 Mar 2007 14:58:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 2/5] revoke: core code
Message-ID: <20070316145855.5604d7d8@lxorguk.ukuu.org.uk>
In-Reply-To: <20070316042600.3e1bd424.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	<20070315173438.efadd514.akpm@linux-foundation.org>
	<84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	<20070316032624.c6db84fc.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
	<20070316042600.3e1bd424.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure that running do_fsync() will guarantee that all sys_write()
> callers will have finished their syscall.  Probably they will have, in
> practice.  But there is logic in the sync paths to deliberately bale out
> if we're competing with ongoing dirtyings, to avoid livelocking.

For device files you really need to call into the device driver for this
(->flush etc).

> However, modifying i_size like this might be a problem - the inode could be
> dirty and it'll get written to disk!  Perhaps we could change i_size_read()
> to cheat and to return zero if there's a revoke in progress.

The cheating is a bit messier than that - you might be revoking on a
cluster file system and I'm still trying to get my head around what the
semantics for that are. Lying about sizes will break the coherency
protocols I think

Serious question - do we actually need revoke() on a normal file ? BSD
has never had this, SYS5 has never had this.

Alan
