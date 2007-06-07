Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXFGLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXFGLTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXFGLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:19:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42159 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXFGLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:19:44 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 07:17:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why does the macro "ZERO_PAGE" take an argument?
Message-ID: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>
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


  probably making a fool of myself here, but what is the purpose of
that single argument to the macro "ZERO_PAGE"?

$ grep -r "define ZERO_PAGE" include
include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      ({ BUG(); NULL; })
include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      virt_to_page(empty_zero_page)
include/asm-v850/pgtable.h:#define ZERO_PAGE(vaddr)     ((void *)0x87654321)
include/asm-mips/pgtable.h:#define ZERO_PAGE(vaddr) \
include/asm-blackfin/pgtable.h:#define ZERO_PAGE(vaddr) (virt_to_page(0))
include/asm-parisc/pgtable.h:#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
include/asm-alpha/pgtable.h:#define ZERO_PAGE(vaddr)    (virt_to_page(ZERO_PGE))
...

  AFAICT, there are no definitions of that macro that actually use
that argument.  is that some kind of historical cruft?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
