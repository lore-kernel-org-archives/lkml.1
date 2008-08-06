Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYHFOas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYHFOas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbYHFOaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:30:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52204 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755038AbYHFOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:30:37 -0400
Date: Wed, 6 Aug 2008 15:13:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long
 Physical Sectors
Message-ID: <20080806151302.1d282747@lxorguk.ukuu.org.uk>
In-Reply-To: <20080806131109.GH2055@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	<1217957207-23116-3-git-send-email-matthew@wil.cx>
	<20080805214651.621263f5@lxorguk.ukuu.org.uk>
	<20080806022255.GC2055@parisc-linux.org>
	<20080806100647.21529284@lxorguk.ukuu.org.uk>
	<20080806131109.GH2055@parisc-linux.org>
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

> Obviously it is going to change per command -- because different
> commands have different sizes.  I was thinking that we could call the
> driver to see if it can handle a particular sector size right after we
> get the IDENTIFY data.  

The drivers need to know if you are going to be using odd sizes regularly
so they can pick between

	-	I do this fine who cares (most chips)
	-	Er uh wtf its not 512 byts (some chip state machines)
	-	FIFO off (performance hit) for this disk
	-	FIFO managed for the odd command thats a funny size
	-	Various other levels of software managed controller
		thumping

It's not a passive thing and we'd want to do it post identify on the
drive pair as it'll often need per channel decisions (eg on FIFO)

Alan
