Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYJFJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYJFJ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYJFJ17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:27:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38469 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751803AbYJFJ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:27:58 -0400
Date: Mon, 6 Oct 2008 10:27:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006102739.16d1a434@lxorguk.ukuu.org.uk>
In-Reply-To: <20081005180154.7cc12486@infradead.org>
References: <20081005180154.7cc12486@infradead.org>
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

> This patch adds, to the existing config option to restrict /dev/mem, the
> reserved regions to the "banned from /dev/mem use" list, so now
> both kernel memory and device-exclusive MMIO regions are banned.

This breaks a whole class of diagnostic and debug tools which quite
intentionally dump the MMIO register space of devices that are live.

Plus it doesn't actually work - if I have /dev/mem open and mmapped you
don't pull the pages from under me....

The problem with the way this is going is the more you take from /dev/mem
the sooner someone is forced to add /dev/mem-proper which undoes it all
again so they can get work done.

It's certainly a useful debug aid to know about such things but I don't
believe it's something you should ban.

Alan
