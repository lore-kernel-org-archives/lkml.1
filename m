Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbXJREVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbXJREVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXJREVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:21:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbXJREVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:21:01 -0400
Date: Wed, 17 Oct 2007 21:20:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <4716DB9A.2060809@rtr.ca>
Message-ID: <alpine.LFD.0.999.0710172117280.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
 <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
 <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org>
 <4716DB9A.2060809@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Mark Lord wrote:
> 
> Oh.. so this bug is supposed to only bite with DEBUG_PAGEALLOC=y ??

Yeah, this particular one really should only bite you with 
DEBUG_PAGEALLOC.

The SG code potentially _derefences_ a field past the end of the SG array, 
but it should be a read, and the result should never be used (it's used to 
calculate the pointer to past the end of the queue, so if it's used, 
there's another bug lurking).

> Then something else is broken, perhaps.  I just saw a long traceback 
> scroll off the top of the screen, with lots of bio_* functions in the 
> list and assumed it was the same bug.
> 
> Mmm.. I'll get out the camera and try it again now..

Please do. I wouldn't be surprised if it's also related to the SG changes, 
but I don't think it's the exact particular bug that Ingo saw.

		Linus
