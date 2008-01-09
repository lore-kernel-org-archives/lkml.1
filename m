Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYAIRLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYAIRLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAIRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:11:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57957 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188AbYAIRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:11:22 -0500
Date: Wed, 9 Jan 2008 17:09:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, udovdh@xs4all.nl
Subject: Re: [RS232] setting trigger-level of fifo
Message-ID: <20080109170907.4b05d71b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080109155412.GX8331@vanheusden.com>
References: <20080109153242.GU8331@vanheusden.com>
	<20080109155412.GX8331@vanheusden.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         serial8250_set_mctrl(&up->port, up->port.mctrl);
>         spin_unlock_irqrestore(&up->port.lock, flags);
> }
> 
> But I don't know how to interface this to an ioctl or so.

tty ioctl calls both ldisc and driver ioctls (in your case the
serial_core ioctl). The triggers get recomputed in the 8250 driver so you
may need to think about how you handle speed changes automatically
adjusting trigger levels.

Alan
