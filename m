Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYHFPYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYHFPYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYHFPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:24:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59265 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755240AbYHFPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:24:08 -0400
Date: Wed, 6 Aug 2008 16:06:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long
 Physical Sectors
Message-ID: <20080806160618.40058068@lxorguk.ukuu.org.uk>
In-Reply-To: <20080806151330.GM2055@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	<1217957207-23116-3-git-send-email-matthew@wil.cx>
	<20080805214651.621263f5@lxorguk.ukuu.org.uk>
	<20080806022255.GC2055@parisc-linux.org>
	<20080806100647.21529284@lxorguk.ukuu.org.uk>
	<20080806131109.GH2055@parisc-linux.org>
	<20080806151302.1d282747@lxorguk.ukuu.org.uk>
	<20080806151330.GM2055@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	-	FIFO managed for the odd command thats a funny size
> 
> ... but it's not the odd command, it's going to be the vast majority of
> them.

Put a 512 byte and a 2K sector sized disk on the same channel and its
probably nearer 50/50.

> 
> > 	-	Various other levels of software managed controller
> > 		thumping
> > 
> > It's not a passive thing and we'd want to do it post identify on the
> > drive pair as it'll often need per channel decisions (eg on FIFO)
> 
> Why can't you just disable the (controller) FIFO whenever any drive
> reports != 512 byte sectors?

Because I'd like to do better than that - and FIFO is only one of the
cases. I think your proposal basically works - providing you identify
both drives before worrying about sector sizes. Most of our other logic
is done that way - the drives are all identified then the controller makes
decisions.

The setup time method then either vetos the disk or accepts it
The existing mode_filter can be used to implement stuff like "PIO only no
DMA" cases
And if we can do it but have problems the qc_issue or device select
methods can be hooked to do the work.

Alan
