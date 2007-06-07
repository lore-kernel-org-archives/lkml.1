Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbXFGSKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbXFGSKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764855AbXFGSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:10:29 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764786AbXFGSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:10:28 -0400
Message-ID: <46684894.5010506@zytor.com>
Date: Thu, 07 Jun 2007 11:04:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain> <20070607163731.GB30044@linux-mips.org>
In-Reply-To: <20070607163731.GB30044@linux-mips.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> Cache aliases.  When the same page of physical memory is mapped twice to
> user space, let's say at address addr and addr + PAGE_SIZE this is normally
> harmless although wasteful on processors with virtually indexed caches as
> long as the page is mapped read-only such as in case of ZERO_PAGE.
> 
> If the same thing happens with a writable page there is the chance of
> severe data corruption.  Some members of the R4000 family are now trying
> to be helpful by throwing the kernel a "virtual coherency" exception.  The
> bad news about this exception is there might be thousands (the theoretical
> worst case would be millions) of it in a single second, so servicing can be
> very expensive.  For the ZERO page this can be avoided by using several
> pages mapped in a way such that their addresses don't conflict.

Note that it can be a *very expensive* waste even on machines that do
this in hardware.  Colouring the zeropage can have sizable performance
advantages for virtually no cost.

	-hpa

