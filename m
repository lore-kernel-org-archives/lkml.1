Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXGDQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXGDQ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXGDQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:58:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41899 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbXGDQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:58:44 -0400
Date: Thu, 5 Jul 2007 01:58:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Message-Id: <20070705015806.6a82463f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <468BADA6.9050609@bull.net>
References: <468BADA6.9050609@bull.net>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2007 16:24:38 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:
> Machines star up whit bit 5 = 0, reading instruction pages via
> NFS has to flush them from L2I.
> 
In our test, we confirmed that this can be fixed by flushing L2I just before 
SetPageUptodate() in NFS.

> 
> I was wondering if instead of modifying do_no_page() and Co., should
> not we make nfs_readpage() be DMA-like?
> (No possible regression for most of the page I/O-s.)
> I.e. it should be the responsibility of a file system to make sure it
> supports instruction pages correctly. The base kernel should provide
> such file systems with an architecture dependent macro...
> 
IMHO, for example, race in cooy-on-write  (was fixed by Tony Luck) has to be
fixed by MemoryManagement layer.
And only a race in do_no_page() seems to be able to be fixed by FS layer.

BTW, can we know whether a page is filled by DMA or not  ?

Thanks,
-Kame

