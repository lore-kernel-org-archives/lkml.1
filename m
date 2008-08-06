Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYHFPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYHFPOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYHFPOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:14:07 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56304 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYHFPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:14:06 -0400
Date: Wed, 6 Aug 2008 09:13:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080806151330.GM2055@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <20080805214651.621263f5@lxorguk.ukuu.org.uk> <20080806022255.GC2055@parisc-linux.org> <20080806100647.21529284@lxorguk.ukuu.org.uk> <20080806131109.GH2055@parisc-linux.org> <20080806151302.1d282747@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806151302.1d282747@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 03:13:02PM +0100, Alan Cox wrote:
> > Obviously it is going to change per command -- because different
> > commands have different sizes.  I was thinking that we could call the
> > driver to see if it can handle a particular sector size right after we
> > get the IDENTIFY data.  
> 
> The drivers need to know if you are going to be using odd sizes regularly
> so they can pick between

It's up to the drive to report the number of sectors it uses.  After
that all regular read/write commands will be doing that size.  Unless
we're in some very bizarre situation, that will be the majority of
accesses to the device.

> 	-	I do this fine who cares (most chips)

Fine, returns 1.

> 	-	Er uh wtf its not 512 byts (some chip state machines)

Fine, returns 0.

> 	-	FIFO off (performance hit) for this disk

Might want to print a message explaining why performance is going to
suck and return 1.

> 	-	FIFO managed for the odd command thats a funny size

... but it's not the odd command, it's going to be the vast majority of
them.

> 	-	Various other levels of software managed controller
> 		thumping
> 
> It's not a passive thing and we'd want to do it post identify on the
> drive pair as it'll often need per channel decisions (eg on FIFO)

Why can't you just disable the (controller) FIFO whenever any drive
reports != 512 byte sectors?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
