Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZAYPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZAYPXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZAYPW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:22:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40739 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754051AbZAYPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:22:55 -0500
Date: Sun, 25 Jan 2009 15:22:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Hugh Dickins <hugh@veritas.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
Message-ID: <20090125152211.18a838f9@lxorguk.ukuu.org.uk>
In-Reply-To: <4977B1D1.2010305@ru.mvista.com>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
	<18807.33113.550070.329912@harpo.it.uu.se>
	<20090121214746.2b15d1de@lxorguk.ukuu.org.uk>
	<4977A6E5.6080506@ru.mvista.com>
	<20090121225808.1f5ffac1@lxorguk.ukuu.org.uk>
	<4977B10B.5050904@ru.mvista.com>
	<4977B1D1.2010305@ru.mvista.com>
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

> >> "Note: only 32-bit writes to the data port are allowed when this bit is
> >> set."
> >>   
> >  
> >   Now tell me who forces you to set that bit (I assume it's the write 
> > buffer enable) for the ATAPI devices?
> 
>    Yes, it's the write buffer enable (about which I have written already).

Yeah that seems the best way to go - not I note that the old drivers/ide
driver programs it right for 16bit I/O or doing mixed 16/32 ..

Patch added to my tree which together with Hugh's change should do the
trick. The others I've checked seem to have no such rule except in VLB
space. Never tried ATAPI in anger on a VLB box but it's easy enough to
address and I'll do a third patch for those.

Alan
