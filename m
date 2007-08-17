Return-Path: <linux-kernel-owner+w=401wt.eu-S1765431AbXHQR6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431AbXHQR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbXHQR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:57:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57835 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951AbXHQR5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:57:54 -0400
Date: Fri, 17 Aug 2007 19:59:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <bryan.wu@analog.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [draft] Blackfin Early Printk implmentation
Message-ID: <20070817175911.GA22046@uranus.ravnborg.org>
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <46C4009F.9090206@redhat.com> <200708171336.40159.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708171336.40159.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 01:36:39PM -0400, Robin Getz wrote:
> The patch (for review - not inclusion - I will send to Bryan if no one has any 
> major objections, and he can push it via git) implements early printk for the 
> Blackfin architecture.
> 
> It also adds an early exception handler, so if an 
> interrupt/exception/violation happens before the kernel enables it's 
> interrupts (yes that does happen periodically, and it is a nice to have a 
> debug feature to help , that we don't go back to the bootloaders exception 
> processing table...
> 
> It also removes some of the crap that was trying to implement the same thing 
> (poorly).

So this patch does three things at least:
-> adds early_printk
-> delete cruft emulating early printk
-> add an early excaption handler

That seems to explain why I could not follow your code changes.
A more fine grained splitup would have helped here.

I noticed that you copied the actual early_printk code from x86_64.
What was preventing you from just using the x86_64 code here?
A simple
#include <arch/x86_64/boot/early_printk.c>
in the blackfin early_printk should do the trick.

alpha btw uses the implementation in lib/*printf.c
Are there a specific reason why blackfin and x86_64 does not do the same?
Thinking that all should do the same so maybe alpha ought to change...

	Sam
