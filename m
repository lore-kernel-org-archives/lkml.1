Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbXLGQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbXLGQKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXLGQKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:10:37 -0500
Received: from [81.2.110.250] ([81.2.110.250]:51731 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbXLGQKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:10:36 -0500
Date: Fri, 7 Dec 2007 16:04:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071207160439.71b7f46a@the-village.bc.nu>
In-Reply-To: <p733auekcly.fsf@bingen.suse.de>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> modern CPU compared to the bus. But the delay really needs to be something
> that is about IO port speed. Ok in theory you could try to measure
> a outb using RDTSC and then use udelay, but first you would need

You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
and make sure the initial default delay is conservative enough before the
CPU speed is computed.

0x80 should be fine for anything PC compatible anyway, its specifically
reserved as a debug port and supported for *exactly* that purpose by
many chipsets.

The afflicted laptop should really be taken up with the vendor. If its
got port 0x80 wrong gods knows what else it might have problems with.

Alan
