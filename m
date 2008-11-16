Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYKPLZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYKPLZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYKPLZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:25:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731AbYKPLZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:25:06 -0500
Date: Sun, 16 Nov 2008 11:25:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Message-ID: <20081116112511.3913123a@lxorguk.ukuu.org.uk>
In-Reply-To: <491FBA29.3000803@kernel.org>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
	<491E4092.5030804@shaw.ca>
	<20081115103424.34f01370@lxorguk.ukuu.org.uk>
	<491FBA29.3000803@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 15:14:01 +0900
Tejun Heo <tj@kernel.org> wrote:

> Alan Cox wrote:
> > On Fri, 14 Nov 2008 21:22:58 -0600
> > Robert Hancock <hancockr@shaw.ca> wrote:
> > 
> >> Justin Piszcz wrote:
> >>> I am trying to find out what the root cause of this error/problem is:
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=462425
> >> The problem is that people assume that timeouts with DRDY like that bug 
> >> refers to must be the same problem when it is often not
> > 
> > The first stopping point is to apply the DRQ drain patch I sent to the
> > list some time ago and is hopefully lined up for 2.6.29. After that point
> > you can begin to look at the remaining cases, until then its hardly worth
> > it.
> 
> Is it really?  For many SATA controllers, DRQ draining isn't really
> necessary.  PATA might be a completely different story tho.

It seems to be needed for various devices and some controllers. Given we
don't know which it seems to be the sensible starting point for almost any
failure involving a DRQ being left on. It won't fix them all but it is
the one case that can easily be eliminated.

Alan
