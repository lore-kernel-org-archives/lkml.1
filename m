Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbXHZAKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbXHZAKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 20:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbXHZAKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 20:10:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38483 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbXHZAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 20:10:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 25 Aug 2007 19:59:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Denys Vlasenko <vda.linux@googlemail.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in
 drivers/mtd/maps/pmcmsp-flash.c
In-Reply-To: <9a8748490708251527n26cc2065n5b8716bd7f65e252@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708251956380.29507@localhost.localdomain>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
 <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
 <200708241141.06358.vda.linux@googlemail.com>
 <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain>
 <9a8748490708251527n26cc2065n5b8716bd7f65e252@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.444, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_6CONS_WORD 0.36)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007, Jesper Juhl wrote:

> On 24/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:

> > actually, i would think kcalloc would be more appropriate here, no?
> >
>
> Why?
>
> msp_parts[i] = kzalloc(pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
>
> seems better to me than
>
> msp_parts[i] = kcalloc(1, pcnt * sizeof(struct mtd_partition), GFP_KERNEL);

i was thinking more along the lines of

msp_parts[i] = kcalloc(pcnt, sizeof(struct mtd_partition), GFP_KERNEL);

which was kind of the obvious implication, no?  unless there's a
reason kcalloc() wouldn't work here, this is pretty much what
kcalloc() was designed for.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
