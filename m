Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYBDF4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYBDF4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYBDF4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:56:00 -0500
Received: from ozlabs.org ([203.10.76.45]:49877 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYBDFz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:55:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] request_irq() always returns -EINVAL with a NULL handler.
Date: Mon, 4 Feb 2008 16:55:36 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801171757.59026.rusty@rustcorp.com.au> <20080202221502.76d48ead.akpm@linux-foundation.org>
In-Reply-To: <20080202221502.76d48ead.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041655.36772.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 17:15:02 Andrew Morton wrote:
> On Thu, 17 Jan 2008 17:57:58 +1100 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > I assume that these ancient network drivers were trying to find out if
> > an irq is available.  eepro.c expecting +EBUSY was doubly wrong.
> >
> > I'm not sure that can_request_irq() is the right thing, but these drivers
> > are definitely wrong.
> >
> > request_irq should BUG() on bad input, and these would have been found
> > earlier.
>
> This breaks non-CONFIG_GENERIC_HARDIRQS architectures.
>
> alpha:
>
> drivers/net/3c503.c: In function 'el2_open':
> drivers/net/3c503.c:382: error: implicit declaration of function
> 'can_request_irq'

Since this code was non-functional before, should we just be removing 
the "check if irq is free" check altogether?

This is Jeff's call, I think.

Rusty.
