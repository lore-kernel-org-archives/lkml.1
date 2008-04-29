Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYD2WDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYD2WDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYD2WC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:02:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:58464 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYD2WC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xdioF1IhAxyujgrpSyYH/p8Se7sO92aAl6PUOEi+O/DjPMJXPRYWeFoGwUmgdUq4AHL5+0itZh7j5K02PjYoulqfqcI9wGJcXduSuposvS0i8THIGZtvfOsCAAsUzfs4YY2rOzcmJHAdrkDfUF+PgnyM913bYLtjgPLAUvuXmzE=
Message-ID: <86802c440804291502q59fc50faue59988b4787d3458@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:02:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] x86: restrict keyboard io ports reservation to make ipmi driver work
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Helge Wagner" <Helge.Wagner@gefanuc.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0804292342060.6003@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0804292342060.6003@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> From: Helge Wagner <Helge.Wagner@gefanuc.com>
>
>  On some of our (single board computer) boards (x86) we are using an
>  IPMI controller that uses I/O ports 0x62 and 0x66 for a KCS (keyboard
>  controller style) IPMI system interface.
>
>  Trying to load the openipmi driver fails, because the ports
>  (0x62/0x66) are reserved for keyboard. keyboard reserves the full
>  range 0x60-0x6F while it doesn't need to.
>
>  Reserve only ports 0x60 and 0x64 for the legacy PS/2 i8042 keyboad
>  controller instead of 0x60-0x6F to allow the openipmi driver to work.
>
>  Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>  ---
>   arch/x86/kernel/setup_32.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
>  Index: linux-2.6/arch/x86/kernel/setup_32.c
>  ===================================================================
>  --- linux-2.6.orig/arch/x86/kernel/setup_32.c
>  +++ linux-2.6/arch/x86/kernel/setup_32.c
>  @@ -127,7 +127,12 @@ static struct resource standard_io_resou
>   }, {
>         .name   = "keyboard",
>         .start  = 0x0060,
>  -       .end    = 0x006f,
>  +       .end    = 0x0060,
>  +       .flags  = IORESOURCE_BUSY | IORESOURCE_IO
>  +}, {
>  +       .name   = "keyboard",
>  +       .start  = 0x0064,
>  +       .end    = 0x0064,
>         .flags  = IORESOURCE_BUSY | IORESOURCE_IO
>   }, {
>         .name   = "dma page reg",
>  --

64 bit need to be fixed too...
        { .name = "keyboard", .start = 0x60, .end = 0x6f,
                .flags = IORESOURCE_BUSY | IORESOURCE_IO },

YH
