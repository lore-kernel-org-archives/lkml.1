Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0CNO7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:59:19 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41894 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab0CNO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:59:16 -0400
Date: Sun, 14 Mar 2010 10:57:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should new kfifo implementation really be exporting that much?
In-Reply-To: <alpine.LFD.2.00.1003140929350.4644@localhost>
Message-ID: <alpine.LFD.2.00.1003141053380.5987@localhost>
References: <alpine.LFD.2.00.1003140929350.4644@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Mar 2010, Robert P. J. Day wrote:

>
>   just curious about how much is being exported from kfifo.c:
>
> $ grep EXPORT_SYMBOL kernel/kfifo.c
> EXPORT_SYMBOL(kfifo_init);
> EXPORT_SYMBOL(kfifo_alloc);
> EXPORT_SYMBOL(kfifo_free);
> EXPORT_SYMBOL(kfifo_skip);
> EXPORT_SYMBOL(__kfifo_in_n);
> EXPORT_SYMBOL(kfifo_in);
> EXPORT_SYMBOL(__kfifo_in_generic);
> EXPORT_SYMBOL(__kfifo_out_n);
> EXPORT_SYMBOL(kfifo_out);
> EXPORT_SYMBOL(kfifo_out_peek);
> EXPORT_SYMBOL(__kfifo_out_generic);
> EXPORT_SYMBOL(__kfifo_from_user_n);
> EXPORT_SYMBOL(kfifo_from_user);
> EXPORT_SYMBOL(__kfifo_from_user_generic);
> EXPORT_SYMBOL(__kfifo_to_user_n);
> EXPORT_SYMBOL(kfifo_to_user);
> EXPORT_SYMBOL(__kfifo_to_user_generic);
> EXPORT_SYMBOL(__kfifo_peek_generic);
> EXPORT_SYMBOL(__kfifo_skip_generic);
> $
>
>   there's a lot there that looks like it should be static, no?  or is
> all of that *meant* to be part of the public kfifo API?

  as a short followup, kfifo.h strongly implies that a lot of the
above shouldn't be exported:

...
/*
 * __kfifo_in_... internal functions for put date into the fifo
 * do not call it directly, use kfifo_in_rec() instead
 */
...
/*
 * __kfifo_out_... internal functions for get date from the fifo
 * do not call it directly, use kfifo_out_rec() instead
 */
...
/*
 * __kfifo_from_user_... internal functions for transfer from user space into
 * the fifo. do not call it directly, use kfifo_from_user_rec() instead
 */
...
/*
 * __kfifo_to_user_... internal functions for transfer fifo data into user space
 * do not call it directly, use kfifo_to_user_rec() instead
 */
...
/*
 * __kfifo_peek_... internal functions for peek into the next fifo record
 * do not call it directly, use kfifo_peek_rec() instead
 */
...
/*
 * __kfifo_skip_... internal functions for skip the next fifo record
 * do not call it directly, use kfifo_skip_rec() instead
 */
...

  anyway, you get the idea.  it would seem that a lot of those EXPORTs
should be removed, no?

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
