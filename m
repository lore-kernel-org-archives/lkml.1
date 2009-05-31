Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZEaKZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZEaKZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbZEaKZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:25:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41050 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756596AbZEaKZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:25:41 -0400
Date: Sun, 31 May 2009 11:26:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
 sanitization
Message-ID: <20090531112630.2c7f4f1d@lxorguk.ukuu.org.uk>
In-Reply-To: <84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com>
References: <20090531015537.GA8941@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
	<84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >        memset(buf->data, 0, N_TTY_BUF_SIZE);
> >        if (PAGE_SIZE != N_TTY_BUF_SIZE)
> >                kfree(...)
> >        else
> >                free_page(...)
> >
> >
> > but quite frankly, I'm not convinced about these patches at all.
> 
> I wonder why the tty code has that N_TTY_BUF_SIZE special casing in
> the first place? I think we can probably just get rid of it and thus
> we can use kzfree() here if we want to.

Some platforms with very large page sizes override the use of page based
allocators (eg older ARM would go around allocating 32K). The normal path
is 4K or 8K page sized buffers.

