Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbYLXScd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbYLXScd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 13:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYLXScZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 13:32:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49218 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbYLXScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 13:32:24 -0500
Date: Wed, 24 Dec 2008 18:32:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory vs. MMIO ordering, again
Message-ID: <20081224183238.3253d7b9@lxorguk.ukuu.org.uk>
In-Reply-To: <gittnv$2qj$1@ger.gmane.org>
References: <gittnv$2qj$1@ger.gmane.org>
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

> MMIO accesses may, in effect, overtake accesses to cached memory that 
> were emitted earlier. A memory barrier isn't sufficient in such a case, 
> but rather the cache must be flushed between the cached memory write and 
> the MMIO access if the two are in any way dependent."
> 
> This seems like BS to me.. Flush the cache? How is a driver supposed to 
> know how to do that? Furthermore, why should it need to worry about this 
>   kind of detail? This seems wrong or at least a low-level detail that 
> normal code should not have to be concerned with.

There isn't really much choice in the matter. However if you are using
the normal pci_map_ and pci_alloc_coherent functions then those have your
cache management built into them and all you have to watch is compiler
funnies.

Alan
