Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbXEUKYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbXEUKYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbXEUKYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:24:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbXEUKYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:24:08 -0400
Message-ID: <465172EC.3010303@redhat.com>
Date: Mon, 21 May 2007 12:22:36 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of
 console_initcall
References: <200705181900.17101.yinghai.lu@sun.com>	 <20070520202332.145d93a6.akpm@linux-foundation.org> <86802c440705202129o6fe9fb89l47aef78e973c36c5@mail.gmail.com>
In-Reply-To: <86802c440705202129o6fe9fb89l47aef78e973c36c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Gerd's patch  (console handover) was merged into mainline. it will
> switch from early_printk to normal console in register_console via
> CON_BOOT flags.. ===> only for x86

Tagging boot consoles (aka early_printk) with CON_BOOT certainly makes 
sense.  Just doing that doesn't work for ia64?

What is the point in making that work on x86 additionally to serial 
support in early_printk?  It might make sense to split away the serial 
bits from early_printk.c and move them out of arch/ into -- say -- 
drivers/serial/, so other architectures can use that too and we have 
only one serial earlyprintk implementation in the kernel.  Not sure it 
is worth the effort given the code size.

cheers,
   Gerd


