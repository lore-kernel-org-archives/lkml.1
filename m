Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbYHZUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbYHZUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYHZUYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:24:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:34006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750776AbYHZUYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:24:23 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/vGF54mITvEDeT0eHVTPFjzbzwRPThCxgrg9oLVC
	Q0nz7ehcz9Roq8
Message-ID: <48B46672.1000902@gmx.de>
Date: Tue, 26 Aug 2008 22:24:18 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-parisc@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: __kernel_suseconds_t is int on PA-RISC (and SPARC64)?
References: <Pine.LNX.4.64.0808262207450.7910@anakin>
In-Reply-To: <Pine.LNX.4.64.0808262207450.7910@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Apparently __kernel_suseconds_t is `int' on PA-RISC (and on SPARC64),
> while it's `long' on all other platforms.
> 
> Is there a specific reason for that?

I don't know for sure, but arch/parisc/kernel/syscall_table.S states:
/* even though manpage says struct timeval contains longs, ours has
  * time_t and suseconds_t -- both of which are safe wide/narrow */
    ENTRY_COMP(setitimer)

So it was probably chosen to be int so that it can be easily used in 32- 
and 64bit kernels (or compat code).

Helge


> This causes compiler warnings in the HP SDC Real Time Clock driver,
> which is shared between PA-RISC and m68k:
> 
> drivers/input/misc/hp_sdc_rtc.c:461: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:461: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:468: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:468: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:475: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:475: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:482: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:482: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:489: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> drivers/input/misc/hp_sdc_rtc.c:489: warning: format '%02d' expects type 'int', but argument 4 has type 'long int'
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
