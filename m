Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXJVUpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXJVUpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXJVUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:45:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbXJVUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:45:27 -0400
Date: Mon, 22 Oct 2007 13:44:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <20071022211617.31f5c63d@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
 <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <Pine.LNX.4.64.0710222137520.7105@anakin>
 <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
 <20071022211617.31f5c63d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Alan Cox wrote:
> 
> Why can't we just make the list one item longer than the entry count and
> stick a NULL on the end of it like normal people ? Then you need one bit
> which ought to be safe for everyone (and if the bit is a macro any CPU
> warped enough to have byte alignment is surely going to have top bits
> spare...)

Well, quite frankly, equally easy is to just add a

	__attribute__((aligned(4)))

or whatever the gcc syntax for that is today.. That guarantees that gcc 
lays things out properly.

		Linus
