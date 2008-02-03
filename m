Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbYBCGPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbYBCGPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYBCGPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:15:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbYBCGPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:15:05 -0500
Date: Sat, 2 Feb 2008 22:15:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] request_irq() always returns -EINVAL with a NULL
 handler.
Message-Id: <20080202221502.76d48ead.akpm@linux-foundation.org>
In-Reply-To: <200801171757.59026.rusty@rustcorp.com.au>
References: <200801171757.59026.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 17:57:58 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> I assume that these ancient network drivers were trying to find out if
> an irq is available.  eepro.c expecting +EBUSY was doubly wrong.
> 
> I'm not sure that can_request_irq() is the right thing, but these drivers
> are definitely wrong.
> 
> request_irq should BUG() on bad input, and these would have been found
> earlier.

This breaks non-CONFIG_GENERIC_HARDIRQS architectures.

alpha:

drivers/net/3c503.c: In function 'el2_open':
drivers/net/3c503.c:382: error: implicit declaration of function 'can_request_irq'

