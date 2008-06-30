Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYF3NvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYF3NvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYF3NvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:51:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33433 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYF3NvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:51:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: usb_get_status(): what a weird implementation !
Date: Mon, 30 Jun 2008 15:51:41 +0200
User-Agent: KMail/1.9.9
Cc: "David Brownell" <david-b@pacbell.net>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200806261011.00287.oliver@neukum.org> <200806301346.11267.oliver@neukum.org> <38b2ab8a0806300541q756e9b6fl445a5ee69d403ce7@mail.gmail.com>
In-Reply-To: <38b2ab8a0806300541q756e9b6fl445a5ee69d403ce7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301551.42252.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 Juni 2008 14:41:37 schrieb Francis Moreau:
> On Mon, Jun 30, 2008 at 1:46 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Montag 30 Juni 2008 13:04:21 schrieb Francis Moreau:

> >> well, it wouldn't be hard to allocated a buf on the stack with correct
> >> alignement
> >> and size for DMA mapping.
> >
> > Where would you put it and meet the alignment requirements?
> >
> 
> wouldn't this code below do the trick ?
> 
> void foo(void)
> {
>     unsigned char __buf[2 * CACHE_LINE_SIZE];
>     unsigned char *buf;
> 
>     buf = ((unsigned long)__buf) + CACHE_LINE_SIZE-1) & ~(CACHE_LINE_SIZE-1);
> }
> 
> but I agree it looks hackish.

If your buffer is smaller than CACHE_LINE_SIZE it should work.
However, this needs input from people who understand DMA in and out.
But how large is 2 * CACHE_LINE_SIZE compared to the kernel stack?

	Regards
		Oliver
