Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXHZQFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXHZQFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXHZQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:05:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57744 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbXHZQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:05:08 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 26 Aug 2007 11:54:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] remove BITS_TO_TYPE macro
In-Reply-To: <880710657292153543@pripojeni.net>
Message-ID: <Pine.LNX.4.64.0708261143470.4267@localhost.localdomain>
References: <880710657292153543@pripojeni.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007, Jiri Slaby wrote:

> remove BITS_TO_TYPE macro
>
> I realized, that it is actually the same as DIV_ROUND_UP, use it instead.

unless there are some patches in the queue, the whole area of rounding
up and aligning is still sort of messy.

kernel.h defines the following:

...
#define ALIGN(x,a)              __ALIGN_MASK(x,(typeof(x))(a)-1)
#define __ALIGN_MASK(x,mask)    (((x)+(mask))&~(mask))
...
#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
...

yet there is no corresponding DIV_ROUND_DOWN() or rounddown(), just
for the sake of consistency. (maybe there's simply no need?)

would someone like to propose a single, consistent standard for those
things?  or is it not worth it?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
