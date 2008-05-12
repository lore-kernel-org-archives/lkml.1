Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbYELKEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbYELKEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYELKEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:04:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56715 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756348AbYELKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:04:34 -0400
Date: Mon, 12 May 2008 10:54:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <bryan.wu@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class
 UARTs in HV Sistemas H8606 board
Message-ID: <20080512105415.6a8fb88c@core>
In-Reply-To: <1210566565-6205-2-git-send-email-cooloney@kernel.org>
References: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
	<1210566565-6205-2-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +#ifdef SERIAL_EXTRA_IRQ_FLAGS
> +		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
> +#endif
> +


We try and keep ifdefs out of code. It is also not clear what you would
do if you had a box where the extra flags depended on the port.

So two suggestions

Either

Add just the line

+		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;

and at the end of 8250.h do

#ifndef SERIAL_EXTRA_IRQ_FLAGS
#define SERIAL_EXTRA_IRQ_FLAGS			0
#endif

or the same but with an argument (unused for now)

SERIAL_EXTRA_IRQ_FLAGS(up)

Alan
