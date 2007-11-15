Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbXKOKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbXKOKEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763990AbXKOKDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:03:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36790 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbXKOKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:03:51 -0500
Date: Thu, 15 Nov 2007 19:05:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1 (memory hotplug x86_64/vmemmap  fix)
Message-Id: <20071115190529.4129deb4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115093851.GA2513@shadowen.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115093851.GA2513@shadowen.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 09:39:15 +0000
Andy Whitcroft <apw@shadowen.org> wrote:

> Can you explain "this is bug" for me.  The routine was __init_refok and
> therefore ! __init and therefore always present.  The logic there must
> guarentee it only calls the bootmem allocator in early boot, and the logic
> has not changed with the annotation change so it should have been safe.
> If by "this is bug" you are saying this is the cause of the warning then
> yes that is true, else could you elaborate.
> 
Sorry I misunderstood that  __init.refok is a section which is freed after boot.
I confrimed it's just a .text section. sorry.


> > +static void __init_refok *__call_bootmem_alloc(int nid, int array_size)
> 
> This indirect makes sense for the sparse safety aspect, only letting the
> caller use this one routine.  I wonder if the name should be more
> explicit.  earlyonly_bootmem_alloc() or something, so that a later
> reader knows from the call site that this is magical and care needs to
> be exercised here.
ok.

Thank you for review.

-Kame

