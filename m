Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZEaRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZEaRJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZEaRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:09:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54357 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753771AbZEaRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:09:33 -0400
Date: Sun, 31 May 2009 18:10:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
 sanitization
Message-ID: <20090531181020.05fb89d5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
References: <20090531015537.GA8941@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
	<84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com>
	<20090531112630.2c7f4f1d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think Pekka meant the other way around - why don't we always just use 
> kmalloc(N_TTY_BUF_SIZE)/kfree(), and drop the whole conditional "use page 
> allocator" entirely?

We certainly can nowdays - the old allocator used to allocate 8K for 4K
and a bit of memory and its many years single we acquired slab so yes it
can go.

> If I'm right, then we could just use kmalloc/kfree unconditionally. Pekka?

Added to the tty queue will do that tomorrow
