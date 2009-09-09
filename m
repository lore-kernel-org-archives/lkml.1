Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZIICzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZIICzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZIICzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:55:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZIICzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:55:12 -0400
Date: Tue, 8 Sep 2009 23:54:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090908235441.04549a29@caramujo.chehab.org>
In-Reply-To: <4AA6F63F.7090009@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 08 Sep 2009 17:26:39 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

> Correct.  You're missing the point: if you follow my recipe, the legacy
> names fall out of the same algorithm.  The first 256 will have the
> traditional names, fully compatible, the 256th entry will be
> /dev/ttyp10, and so on.
> 
> >>
> >> 	sprintf(name, "%cty%c%x", slave ? 't' : 'p',
> >> 		"pqrstuvwxyzabcde"[(index >> 4) & 15],
> >> 		((index >> 4) & ~15) | (index & 15));

> > But it will also be a little more weird.
> 
> IMO, no less weird than a random shift from one naming algorithm to
> another in the middle of the sequence.

Ok, your algorithm will be fully compatible with the old naming system, as
you're encoding the nibbles on this order:
	[7:4][3:0][*:8]

>From one side, I liked the idea of not having any arbitrary maximum limit, but
from other side, It seems easier to implement than to describe it in English,
at devices.txt. Maybe the solution is to explain it by examples.

Also, if we look at the current device designation, we already have some rule
changes. 

For example, for SCSI discs, there are lots of different majors: major 8 (for
the first 16 disks), major 65 (for the next 16 disks), major 66 (for the next
16 disks), major 68 (for more 16 disks)... For sure something that comes from
the time where minors were limited to 256.

Another example: major 112 block has a new rule for devices above 26 (well,
something close to what you're proposing), except that they are just reverting
the nibbles order, instead of using a weird order just to keep backward
compatibility.

Anyway, I'll prepare a new RFC using your algorithm and documenting it.

Cheers,
Mauro
