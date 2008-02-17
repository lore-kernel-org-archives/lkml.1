Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYBQWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYBQWev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYBQWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:34:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50287 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934AbYBQWeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:34:44 -0500
Date: Sun, 17 Feb 2008 22:25:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "David P. Reed" <dpreed@reed.com>
Subject: Re: [PATCH 1/3] x86: fix init_8259A() to not use outb_pic
Message-ID: <20080217222552.1af463b4@core>
In-Reply-To: <6gr00g$g7cm8h@smtp01.lnh.mail.rcn.net>
References: <6gr00g$g7cm8h@smtp01.lnh.mail.rcn.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 16:56:28 -0500 (EST)
"David P. Reed" <dpreed@reed.com> wrote:

> fix init_8259A() which initializes the 8259 PIC to not use outb_pic,
> which is a renamed version of outb_p, and delete outb_pic define.

NAK

The entire point of inb_pic/outb_pic is to isolate the various methods
and keep the logic for delays in one place. Undoing this just creates a
nasty mess.

Quite probably inb_pic/outb_pic will end up as static inlines that do inb
or outb with a udelay of 1 or 2 but that is where the knowledge belongs.
