Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbYALV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbYALV1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYALV1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:27:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44614 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756023AbYALV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:27:34 -0500
Date: Sat, 12 Jan 2008 21:24:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: akpm@osdl.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
Message-ID: <20080112212457.3bf534af@lxorguk.ukuu.org.uk>
In-Reply-To: <20080112201543.GB12775@kvack.org>
References: <20080112201543.GB12775@kvack.org>
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

On Sat, 12 Jan 2008 15:15:43 -0500
Benjamin LaHaise <bcrl@kvack.org> wrote:

> When using kvm with a serial console, the serial driver will print out 
> "too much work for irq4" on any heavy activity (ie vi on a file repainting 
> the terminal).  This message is entirely spurious, as output continues to 
> work fine.  Remove the message as it corrupts screen output and is far too 
> easy to trigger.

NAK. This is a qemu/kvm emulation bug. The real check is there to catched
jammed IRQs and combined with the IRQ bug handling nowdays does actually
do the intended job.

Our serial port code (correctly) interprets a continuous stream of bytes
at an impossible bit rate as an error. KVM should be emulating to some
extent at least the timing on serial interfaces or using a virtualised
interface.

Alan
