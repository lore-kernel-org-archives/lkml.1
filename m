Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYJ1Urz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYJ1Urz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJ1Urr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:47:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYJ1Urq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:47:46 -0400
Date: Tue, 28 Oct 2008 13:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, heiko.carstens@de.ibm.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
 schedule_on_each_cpu()
Message-Id: <20081028134536.9a7a5351.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810280914010.15939@quilx.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	<2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	<20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081027145509.ebffcf0e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0810280914010.15939@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:25:31 -0500 (CDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 27 Oct 2008, Andrew Morton wrote:
> 
> > Can we fix that instead?
> 
> How about this fix?
> 
> 
> 
> Subject: Move migrate_prep out from under mmap_sem
> 
> Move the migrate_prep outside the mmap_sem for the following system calls
> 
> 1. sys_move_pages
> 2. sys_migrate_pages
> 3. sys_mbind()
> 
> It really does not matter when we flush the lru. The system is free to add
> pages onto the lru even during migration which will make the page 
> migration either skip the page (mbind, migrate_pages) or return a busy 
> state (move_pages).
> 

That looks nicer, thanks.  Hopefully it fixes the
lockdep-warning/deadlock...

I guess we should document our newly discovered schedule_on_each_cpu()
problems before we forget about it and later rediscover it.

