Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXJZQNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXJZQNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761078AbXJZQNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:13:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761427AbXJZQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:13:29 -0400
Date: Fri, 26 Oct 2007 09:12:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes
 breakage
In-Reply-To: <20071026155648.GB4321@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.0.999.0710260909390.30120@woody.linux-foundation.org>
References: <20071026155648.GB4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Russell King wrote:
>
> commit 8562043606430185cad26d085d46adcc7ad67fd1 is broken, causing:
> 
>   CC      drivers/ide/pci/cmd64x.o
>   CC      drivers/ide/pci/hpt366.o
> drivers/ide/pci/hpt366.c:1428: error: hpt366_chipsets causes a section type conflict
> 
> and therefore should be reverted.
> 
> The problem arises because hpt366 has other data marked with __devinitdata,
> so the compiler tries to define the initdata section with read-write
> attributes at one point, and read-only attributes when encountering the
> const-but-devinitdata declaration:

Sad. This is not too uncommon, but yeah, it's really sad that we cannot 
use "const" (as a compiler type safety marker) together with section 
definitions (to get it put in special init sections).

Bartlomiej - I don't think we need to revert the whole commit, but all 
those "static const xyz __devinitdata = { .." things probably do need to 
have the const removed, even if it would be otherwise correct ;(

		Linus
