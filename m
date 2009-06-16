Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZFPIfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZFPIfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFPIfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbZFPIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:35:23 -0400
Date: Tue, 16 Jun 2009 01:35:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steve Wise <swise@opengridcomputing.com>, zygo.blaxell@xandros.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
Message-Id: <20090616013520.e9881fe7.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0906161022210.7457@wotan.suse.de>
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
	<alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>
	<4A36C55F.6060002@opengridcomputing.com>
	<20090615152959.7d4f4982.akpm@linux-foundation.org>
	<alpine.LNX.2.00.0906161022210.7457@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 10:23:08 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 15 Jun 2009, Andrew Morton wrote:
> 
> > > > this doesn't really qualify for trivial tree, as it introduces a 
> > > > significant code change. Adding some CCs.
> > > Looks ok to me.  Its dumb to aquire the lock you're gonna free anyway.  
> > > Maybe some BUG_ON() that sez nobody better be holding this lock?
> > CONFIG_DEBUG_OBJECTS_FREE could detect the freeing of a held rwlock. 
> > But probably it hasn't been wired up to handle rwlocks.
> 
> Hmm, in fact ... am I just completely blind, or is the only user of 
> CONFIG_DEBUG_OBJECTS_FREE the timer code?

Could be.  That infrastructure hasn't really been followed up on yet.

There's also CONFIG_DEBUG_LOCK_ALLOC which perhaps could/should be
implemented via debugobjects.

