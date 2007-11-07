Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbXKGNJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbXKGNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXKGNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:09:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50430 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830AbXKGNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:09:49 -0500
Date: Wed, 7 Nov 2007 13:09:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] libata: Support PIO polling-only hosts.
Message-ID: <20071107130940.16b5ea86@the-village.bc.nu>
In-Reply-To: <20071107081052.GA25913@linux-sh.org>
References: <20071107081052.GA25913@linux-sh.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 17:10:52 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> By default ata_host_activate() expects a valid IRQ in order to
> successfully register the host. This patch enables a special case
> for registering polling-only hosts that either don't have IRQs
> or have buggy IRQ generation (either in terms of handling or
> sensing), which otherwise work fine.
> 
> Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
> and pass in a NULL IRQ handler or invalid (< 0) IRQ.

NAK

Zero is "no IRQ", please use that for polling not "< 0"

> + *	A NULL @irq_handler or invalid IRQ skips the IRQ registration
> + *	and expects the host to have set polling mode on the port.
> + *

There is no need to llow NULL irq_handler as a different case here. Any
caller can provide (NULL, 0). If anything you might want to warn if they
provide IRQ 0, and a handler

