Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYAHCBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYAHCBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYAHCBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:01:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47206 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752407AbYAHCBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:01:41 -0500
Date: Tue, 8 Jan 2008 01:58:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080108015836.554bb144@lxorguk.ukuu.org.uk>
In-Reply-To: <4782BC56.9050607@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<9BeZN-3Gf-5@gated-at.bofh.it>
	<9BnTB-1As-31@gated-at.bofh.it>
	<9BrX4-8go-1@gated-at.bofh.it>
	<9BuBG-4eR-51@gated-at.bofh.it>
	<9BvRd-6aL-71@gated-at.bofh.it>
	<9GRQW-1DX-13@gated-at.bofh.it>
	<9GSah-23W-1@gated-at.bofh.it>
	<9GSDy-2GD-23@gated-at.bofh.it>
	<9GTpK-40d-15@gated-at.bofh.it>
	<9GUvy-5H2-11@gated-at.bofh.it>
	<9GVKU-7SS-25@gated-at.bofh.it>
	<E1JBxnV-00046d-CS@be1.7eggert.dyndns.org>
	<478281A6.1000704@zytor.com>
	<alpine.LSU.0.999.0801072226060.16143@be1.lrz>
	<4782A355.1070207@zytor.com>
	<alpine.LSU.0.999.0801072316440.16143@be1.lrz>
	<4782AED5.1060406@keyaccess.nl>
	<4782B4B9.2020608@zytor.com>
	<4782BC56.9050607@reed.com>
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

> The PIT usage for calibrating the delay loop can be moderated, if need 
> by, by using the PC BIOS which by definition uses the PIT correctly it 
> its int 15 function 83 call..   Just do it before coming up in a state 
> where the PC BIOS int 15h calls no longer work.  I gave code to do this 
> in a much earlier message.

And as I've said before we don't know if we have a PC BIOS. If we are
running from a kexec or on a Macintoy with EFI or an Xbox we may not.

As per previous discussions for the PIT we can simply guess a safe
initial udelay value and then tune the real one.

Alan
