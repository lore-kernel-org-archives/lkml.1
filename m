Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506AbXFGJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbXFGJGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXFGJGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:06:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39427 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbXFGJGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:06:08 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 05:04:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: trying to summarize/organize the page allocation routines
Message-ID: <Pine.LNX.4.64.0706070442530.6253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  not surprisingly, there's a bit of chaos in the variety of page
allocation routines that can be used to do equivalent things.

  just related to the previously-discussed DMA stuff, there are the
variations:

  * page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
  * (void *)__get_free_pages(__GFP_DMA,...
  * __get_dma_pages(...)

so you can use the type flag "GFP_DMA", or the modifier flag
"__GFP_DMA", or call __get_dma_pages() directly.  so is there a
consensus on what a uniform usage should be?  (i think it's already
agreed that __get_dma_pages() can be tossed.)  but there's more.

  while get_zeroed_page() exists to allocate a single zero-filled page
and return its logical address, there's a number of calls to
__get_free_page that use an action modifier of __GFP_ZERO that
could be rewritten as get_zeroed_page(), no?

  and if get_zeroed_page() is a useful shortcut, why not an equivalent
get_zeroed_pages() for consistency with alloc_page/alloc_pages and
__get_free_page/__get_free_pages?

  a single piece of documentation explaining stuff like this would be
handy, as well as a consistent usage of all of the above.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
