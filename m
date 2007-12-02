Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXLBOB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXLBOB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 09:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXLBOBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:01:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39391 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754107AbXLBOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:01:48 -0500
Date: Sun, 2 Dec 2007 13:57:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: bbpetkov@yahoo.de
Cc: yme@gollum.tnic, Lucy McCoy <lucy@keyspan.com>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071202135734.323428c5@the-village.bc.nu>
In-Reply-To: <20071202080340.GB6528@gollum.tnic>
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
	<20071118131130.GA3991@gollum.tnic>
	<20071126141852.a609cdb6.akpm@linux-foundation.org>
	<20071130054500.GB17350@gollum.tnic>
	<4750471F.5050007@keyspan.com>
	<20071202080340.GB6528@gollum.tnic>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 09:03:40 +0100
Borislav Petkov <yme@gollum.tnic> wrote:

> On Fri, Nov 30, 2007 at 09:23:43AM -0800, Lucy McCoy wrote:
> > Hi All,
> >
> > I've been too busy to get to this but i'd rather not use the code fragment 
> > i sent Boris to try.  It would be better to go ahead with the tty setup if 
> > the pointer is not NULL, otherwise use the defaults and not reference the 
> > NULL pointer. I'll see if I can get to this today.
> you might also want to take a look at usa90_indat_callback() - there is
> port->tty accessed again and this time it kills the machine completely when
> something is sent over the serial line from the other end (through minicom, for
> example). Oops is at
> 
> http://www.screenshots.cc/view_image/ab9a1837/cimg00772.jpg

Change it to if (tty && urb->actual_length) in that function and it'll
probably cure it
