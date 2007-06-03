Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbXFCInV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbXFCInV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXFCInO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:43:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42406 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXFCInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:43:13 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 04:41:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: __get_free_pages:  can GFP_DMA omit GFP_KERNEL and GFP_ATOMIC?
Message-ID: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
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


a two-parter:

  first, can a call to __get_free_pages to allocate DMA-able memory
omit specifying either of GFP_KERNEL or GFP_ATOMIC?  love's book on
kernel development strongly suggests you need to specify one or the
other, but there are a few instances in the tree like this:

drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
drivers/s390/net/claw.c:                   p_buff=(void *)__get_free_pages(__GFP_DMA,

where you can see that the only type flag is __GFP_DMA.  is that
meaningful?

  and, second, i only noticed this as i was going to submit a short
patch to replace __get_free_pages calls for DMA-able memory with the
existing equivalent macro __get_dma_pages.  is that still considered a
worthwhile cleanup?  there's not that many examples of it, and it
would just make things consistent.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
