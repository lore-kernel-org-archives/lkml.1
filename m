Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYFXWAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYFXWAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYFXV7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:59:42 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44340 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114AbYFXV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:59:41 -0400
Message-ID: <48616AAE.703@freescale.com>
Date: Tue, 24 Jun 2008 16:44:14 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, randy.dunlap@oracle.com,
       corbet@lwn.net, torvalds@linux-foundation.org
Subject: Re: [PATCH] Add alloc_pages_exact() and free_pages_exact()
References: <1214325649-26075-1-git-send-email-timur@freescale.com> <1214343218.12367.58.camel@nimitz>
In-Reply-To: <1214343218.12367.58.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:

> This looks like a really good idea.  It looks pretty good to me, no
> functional problems.  

Thanks.

> I think the thing that confused me was trying to figure out if
> 'alloc_end' was the end of what we *did* allocate from
> __get_free_pages() or if it was the *goal* allocation end.
> 
> 'used' also seemed like a slightly strange variable name because it
> points to the memory which is about to be freed and ends up *unused*.

This function is taken almost verbatim from alloc_large_system_hash().  I
figured if the terminology was good for that function, it's good for mine.

> I'll offer this up just in case you like it better.  For me, it is
> easier to parse, and should do the exact same thing.  I also think it's
> slightly nicer to do the arithmetic on 'struct page *' rather than
> vaddrs in 'unsigned long'.  It is _slightly_ cheaper not having to do a
> virt_to_page() on each free_page() call.  The same would go for the free
> side as well.

It does seem to be an improvement, although AKPM just accepted this patch.  I'd
hate to bother him with a replacement patch for something so minor.

-- 
Timur Tabi
Linux kernel developer at Freescale
