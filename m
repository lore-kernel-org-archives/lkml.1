Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXBZSUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXBZSUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXBZSUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:20:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030401AbXBZSUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:20:31 -0500
Date: Mon, 26 Feb 2007 10:13:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
In-Reply-To: <20070226180635.GA644@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>
References: <20070226180635.GA644@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Oleg Nesterov wrote:
> 
> I know nothing about floppy, but I guess the reason is floppy_disable_hlt().
> 
> Sorry for the offtopic question, is it really needed? According to grep, floppy
> is the only one user of disable_hlt().

I suspect you'd have a hard time finding a machine where it was broken any 
more.

But it used to be that the native (aka "braindamaged and idiotic") DMA by 
the motherboard southbridge chipset (and apparently _only_ that) had 
problems with the CPU being halted on some motherboards, and would corrupt 
data if the CPU was halted while the DMA took place.

We never bothered to even figure out why it happened, though. It was 
undeniable that there were people who had trouble with "hlt" and the 
floppy driver, but it is not clear what the cause was.

That's a _loong_ time ago, though, and it *probably* hasn't been an issue 
on any recent machine. People just don't care enough to test, especially 
since the upside is negligible, and the downside for when it would trigger 
is huge.

The floppy is still pretty much the only user of native motherboard (aka 
i8237) DMA'ing for most people. Some old ISA sound-cards may do it, of 
course. But any PCI device will do its own DMA rather than rely on the 
broken 8237 DMA engine, so for all I know, the bug - whatever it ever 
ended up being - could still be there.

			Linus
