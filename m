Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbXJVTuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbXJVTuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbXJVTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:50:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbXJVTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:50:43 -0400
Date: Mon, 22 Oct 2007 12:49:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <Pine.LNX.4.64.0710222137520.7105@anakin>
Message-ID: <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
 <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <Pine.LNX.4.64.0710222137520.7105@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:
>
> Better safe than sorry...
> 
> Is it possible that a chain entry pointer has bit 1 set on architectures
> (e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
> not 4?

Better make sure that such alignment never happens... But no, I don't 
think it will, since these things would generally always have to be 
allocated with an allocator, and the *allocator* won't return 2-byte 
aligned data structures.

		Linus
