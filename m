Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXHFSlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXHFSlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761031AbXHFSlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:41:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760447AbXHFSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:41:08 -0400
Date: Mon, 6 Aug 2007 11:40:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] radix-tree: use indirect bit
Message-Id: <20070806114055.704b78d8.akpm@linux-foundation.org>
In-Reply-To: <20070802052446.GC31121@wotan.suse.de>
References: <20070802052446.GC31121@wotan.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 07:24:46 +0200 Nick Piggin <npiggin@suse.de> wrote:

> Rather than sign direct radix-tree pointers with a special bit, sign
> the indirect one that hangs off the root. This means that, given a
> lookup_slot operation, the invalid result will be differentiated from
> the valid (previously, valid results could have the bit either set or
> clear).
> 
> This does not affect slot lookups which occur under lock -- they
> can never return an invalid result. Is needed in future for lockless
> pagecache.

so.. we added 30 bytes of text to radix-tree.o for no purpose?
