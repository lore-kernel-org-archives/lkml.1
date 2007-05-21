Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXEUJpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXEUJpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbXEUJpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:45:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:54402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759716AbXEUJpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:45:22 -0400
Date: Mon, 21 May 2007 12:42:21 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Message-ID: <20070521104221.GU2012@bingen.suse.de>
References: <200705181900.17101.yinghai.lu@sun.com> <20070520202332.145d93a6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520202332.145d93a6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 08:23:32PM -0700, Andrew Morton wrote:
> On Fri, 18 May 2007 19:00:16 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
> > 
> > Make early_uart to use early_param, so uart console can be used earlier.
> > Make it to be bootconsole with CON_BOOT flag, so can use console handover
> > feature. and it will switch to corresponding normal serial console automatically.
> > new command line will be
> > 
> > earlycon=uart,io,0x3f8,9600n8
> > earlycon=uart,io,0x3f8,9600n8 console=tty0
> > 
> > it will print in very early stage
> > Early serial console at I/O port 0x3f8 (options '9600n8')
> > later for console it will print
> > console handover: boot [uart0] -> real [ttyS0]
> 
> I'll queue this up for some testing, but I'd be a bit reluctant to send it
> into Linus due to my poor understanding of what it actually does.  What
> _is_ an early console, and how does it differ from a non-early one?

It is someone's reimplemention of earlyprintk= for another architecture
that happens to mostly work on x86 too because the code is not ifdeffed. 
I don't think it makes much sense on x86 though because earlyprintk exists.

-Andi

