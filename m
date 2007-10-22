Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbXJVVsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbXJVVsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXJVVsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:48:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbXJVVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:48:07 -0400
Date: Mon, 22 Oct 2007 14:47:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <20071022224343.4abf3c96@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
 <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <Pine.LNX.4.64.0710222137520.7105@anakin>
 <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
 <20071022211617.31f5c63d@the-village.bc.nu>
 <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
 <20071022224343.4abf3c96@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Alan Cox wrote:

> For structures, not array elements or stack objects. Does gcc now get
> aligned correct as an attribute on a stack object ?

I think m68k stack layout still guarantees 4-byte-alignment, no?

> Still doesn't answer the rather more important question - why not just
> stick a NULL on the end instead of all the nutty hacks ?

You still do need one bit for the discontiguous case, so it's not like you 
can avoid the hacks anyway (unless you just blow up the structure 
entirely) and make it a separate member). So once you have that 
bit+pointer, using a separate NULL entry isn't exactly prettier. 

Especially as we actally want to see the difference between 
"end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
anyway, you should probably use something like "all-ones".

			Linus
