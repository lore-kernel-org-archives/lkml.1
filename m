Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYCQHja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYCQHja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYCQHjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:39:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYCQHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:39:21 -0400
Date: Mon, 17 Mar 2008 08:41:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Message-ID: <20080317074146.GG27015@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015825.0C0171B41E0@basil.firstfloor.org> <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com> <20080317070208.GC27015@one.firstfloor.org> <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com> <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> when node_boot_start is 512M alignment, and align is 1024M, offset
> could be 512M. it seems
> i = ALIGN(i, incr) need to do sth with offset...

It's possible that there are better fixes for this, but at least
my simple patch seems to work here. I admit I was banging my
head against this for some time and when I did the fix I just
wanted the bug to go away and didn't really go for subtleness.

The bootmem allocator is quite spaghetti in fact, it could
really need some general clean up (although it's' not quite
as bad yet as page_alloc.c)

-Andi
