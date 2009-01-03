Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbZACXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbZACXOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760019AbZACXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:14:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41123 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759941AbZACXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:14:08 -0500
Date: Sat, 3 Jan 2009 23:14:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
Message-ID: <20090103231419.197727ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103205628.GE1666@elf.ucw.cz>
References: <20090103124400.GA1572@ucw.cz>
	<20090103201955.186974bb@lxorguk.ukuu.org.uk>
	<20090103202740.GC1666@elf.ucw.cz>
	<20090103203044.0166b561@lxorguk.ukuu.org.uk>
	<20090103205628.GE1666@elf.ucw.cz>
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

> Is there concrete architecture where it breaks? I'd expect i386/x86-64
> to be safe, and pretty much everyone to be safe as long as that long
> is aligned.... or that was the result of arch-maintainers
> discussion...

It'll break on x86 if gcc decides to cache the value and you don't have
explicit barriers. If the long is not aligned it's not safe on x86 at all.
 
> I'd really like to document if it is right or not, so that I can point
> people to documentation...

We should always tell people to use atomic/set_bit etc. There *are* cases
you can get away with it but it is far far better that the default is the
safe one because most driver writers do not have a detailed knowledge of
gcc code generation, processor quirks and barriers. If in a specific case
its a performance hit then its worth optimising that case.

Alan
