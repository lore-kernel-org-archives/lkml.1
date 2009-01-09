Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZAIMI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZAIMI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZAIMIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:08:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47300 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbZAIMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:08:17 -0500
Date: Fri, 9 Jan 2009 12:07:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Tejun Heo <tj@kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] libata: use WARN_ON_ONCE on hot paths
Message-ID: <20090109120730.5c80fc68@lxorguk.ukuu.org.uk>
In-Reply-To: <49673D02.6000002@garzik.org>
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
	<20090108221753.78648cd6@daedalus.pq.iki.fi>
	<20090108125317.648397d2@infradead.org>
	<49667C36.4080300@gmail.com>
	<20090108143127.437c15de@infradead.org>
	<4966974B.3090700@gmail.com>
	<49672166.4050606@gmail.com>
	<496724A2.5030400@kernel.org>
	<c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>
	<49673D02.6000002@garzik.org>
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

> If I had to guess, I would say that Arjan's patches assume it is OK to 
> treat two ports on a single IDE controller as completely independent, 
> when that is not really the reality of the hardware.

The PCI probe paths and the setup paths of several of the PATA
controller drivers know they are single threaded in a few spots so it
wouldn't suprise me in the slightest. Really this async stuff needs to
spend 2 or 3 months in -next getting the kinks worked out so that driver
assumptions can be pinned down and fixed, and someone can give it an API
with names that anyone but Arjan understands ;)

Alan
