Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYGIQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYGIQWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYGIQWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:22:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42463 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753454AbYGIQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:22:36 -0400
Date: Wed, 9 Jul 2008 16:49:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: "Miquel van Smoorenburg" <miquels@cistron.nl>, dhowells@redhat.com,
       akpm@linux-foundation.org, alan@redhat.com,
       Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Message-ID: <20080709164929.799e4e05@the-village.bc.nu>
In-Reply-To: <4561.1215612914@redhat.com>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	<20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	<4561.1215612914@redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 15:15:14 +0100
David Howells <dhowells@redhat.com> wrote:

> Miquel van Smoorenburg <miquels@cistron.nl> wrote:
> Maybe, but have you looked at i2o_cfg_passthru()?  Take this, for example:
> 
> 			/* Allocate memory for the transfer */
> 			p = kmalloc(sg_size, GFP_KERNEL);
> 			...
> 			//TODO 64bit fix
> 			sg[i].addr_bus = virt_to_bus(p);
> 
> That looks distinctly dodgy.  virt_to_bus() returns a 64-bit address, and as

Agreed - stick | GFP_DMA32 on the end then ;)


Alan
