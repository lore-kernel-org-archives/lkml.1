Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbYLYAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbYLYAMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 19:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYLYAME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 19:12:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46518 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbYLYAMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 19:12:03 -0500
Date: Thu, 25 Dec 2008 00:11:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: Memory vs. MMIO ordering, again
Message-ID: <20081225001144.48423fea@lxorguk.ukuu.org.uk>
In-Reply-To: <4952A68E.2030906@shaw.ca>
References: <gittnv$2qj$1@ger.gmane.org>
	<20081224183238.3253d7b9@lxorguk.ukuu.org.uk>
	<4952A68E.2030906@shaw.ca>
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

> What that documentation is suggesting is that MMIO writes to uncached 
> memory (what the normal mapping functions will give you) can pass 
> previous writes to cached memory. It doesn't indicate how this is to be 
> avoided, however.

They can. How you avoid it depends upon the bus but the problem is really
really rare as a corner case and almost the only device affected is
graphics because nobody uses cached memory on the PCI bus except graphics
cards and a couple of obscure other cases like I2O.

The graphics people implement various fencing operations and they are
generally tied down low level with AGP, GARTs and other places mere
mortals (ie most people except the DRI team) should not tread ;)

You need to distinguish between cachable memory remote on things like the
PCI bus (eg frame buffers) which are your problem and cachable memory in
the sense of main memory, which is handled by the pci_map functions or
kept coherent if allocated via the PCI coherent memory allocator - in
which case all you have to watch is the compiler and write buffers on the
CPU.

