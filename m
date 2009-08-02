Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZHBUQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZHBUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZHBUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:16:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56850
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbZHBUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:16:57 -0400
Date: Sun, 02 Aug 2009 13:17:05 -0700 (PDT)
Message-Id: <20090802.131705.81498579.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090729112509.GN4148@kernel.dk>
References: <20090729112509.GN4148@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 29 Jul 2009 13:25:10 +0200

> -#define NR_SYSCALLS		327
> +#define NR_SYSCALLS		328

When you increase this value, you have to add entries to all of the
syscall tables.  The syscall dispatch checks against this as a limit,
so if you don't explicitly add an entry to all the tables, it's
possible to deref garbage past the end of the table and try to jump to
it as a syscall.

And if you somehow arrange for adding a compat syscall entry here for
this, and build the perf tools 32-bit, you can forego all of these
rediculious issues with trying to get a 64-bit BFD library.  If the
perf tools are written portably and use types like u64 etc. for
holding addresses and similar things, this should not be an issue.

The 32-bit sparc BFD library has full support for all the 64-bit
binary formats and whatnot.
