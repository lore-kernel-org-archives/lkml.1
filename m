Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbXLEJcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbXLEJcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXLEJb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:31:58 -0500
Received: from elvis.franken.de ([193.175.24.41]:38907 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbXLEJb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:31:57 -0500
Date: Wed, 5 Dec 2007 10:25:06 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Andy Whitcroft <apw@shadowen.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Message-ID: <20071205092506.GA6691@alpha.franken.de>
References: <20071202194346.36E3FDE4C4@solo.franken.de> <20071203155317.772231f9.akpm@linux-foundation.org> <20071204234112.GA12352@alpha.franken.de> <20071204192738.54e79a97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204192738.54e79a97.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 07:27:38PM -0800, Andrew Morton wrote:
> grumble.
> 
> These:
> 
> > +#define READ_SC(p, r)        readb((p)->membase + RD_##r)
> > +#define WRITE_SC(p, r, v)    writeb((v), (p)->membase + WR_##r)
> 
> and these:
> 
> > +#define READ_SC_PORT(p, r)     read_sc_port(p, RD_PORT_##r)
> > +#define WRITE_SC_PORT(p, r, v) write_sc_port(p, WR_PORT_##r, v)
> 
> really don't need to exist.  All they do is make the code harder to read.

but they make the code safer. The chip has common register and port
registers, which are randomly splattered over the address range. And
some of them are read only, some write only. Read only and Write
only register live at the same register offset and their function
usually doesn't have anything in common. By using these macros I'll
get compile errors when doing a READ_SC from a write only register
and vice versa. I will also get compile errors, if I try to access a
common register via READ_SC_PORT/WRITE_SC_PORT. 

If there is a better way to get more readable code for you and
the safety I'd like, just tell me.

> Think of the poor reader who sees this:
> 
> 		status = READ_SC_PORT(port, SR);
> 
> and then goes madly searching for "SR".

which he then finds by this name in the data sheet. All the register
names are named as close to the datasheet as possible. And I consider
consulting datasheets when looking at drivers a pretty good idea.

> Code is written once and is read a thousand times.  Please optimise for
> reading.

it's no big deal to change that, but is getting bitten by stupid chips
worth it ? I'd prefer to get a compile error than debugging a runtime
error.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
