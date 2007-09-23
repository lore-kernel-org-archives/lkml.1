Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXIWQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXIWQfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXIWQfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:35:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34262 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXIWQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:35:36 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 23 Sep 2007 12:33:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
In-Reply-To: <20070923153243.GE8127@redhat.com>
Message-ID: <Pine.LNX.4.64.0709231226140.14224@localhost.localdomain>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org>
 <20070923153243.GE8127@redhat.com>
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

On Sun, 23 Sep 2007, Dave Jones wrote:

> There is one useful argument for memzero (or bzero to give it its
> proper name), and that's that it's impossible to screw up. I'm still
> amazed at how many times I see
>
> 	memset (x,size,0);
>
> in various code. So much so, that my editor highlights it now to
> spot it during code review.  As does my mail client.  To be on the
> safe side, I also have a cron job grepping for it in my
> ~/Mail/commits for all the projects I'm interested in.

  taking a step back, regardless of what constitutes a sane versus
not-sane definition of a useful macro, i think a lot of the content of
kernel.h could be moved out of there and put in a more appropriate
header file called, say, macros.h.

  the first comment in kernel.h claims that

/*
 * 'kernel.h' contains some often-used function prototypes etc
 */

but there's buckets more stuff in there than just some function
prototypes.  macros for type limits, alignment, array sizes, rounding,
and on and on.  and as for those prototypes, is there any reason that
kernel.h includes them explicitly for the contents of lib/vsprintf.c
rather than just including, say, a hypothetical vsprintf.h?  just
curious.

in any case, it would seem that kernel.h could stand a good cleaning.
it give the impression of just being an arbitrary dumping ground when
folks can't figure out where to put something.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
