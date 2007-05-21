Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbXEUQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbXEUQxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEUQx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:53:28 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:36779 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbXEUQx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:53:27 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Date: Mon, 21 May 2007 10:53:33 -0600
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <200705181900.17101.yinghai.lu@sun.com> <20070520214657.fcf5e9ce.akpm@linux-foundation.org> <86802c440705202356n3311b70bg92e1b9c500fc386f@mail.gmail.com>
In-Reply-To: <86802c440705202356n3311b70bg92e1b9c500fc386f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211053.34131.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 12:56:37 am Yinghai Lu wrote:
> Bjorn,
> I can not find fixmap.h for ia64.....hope you can use ioremap instead,
> then we can create one dummy fixmap.h in include/asm-ia64

ia64 ioremap should work early enough, so it doesn't have fixmap.
Seems like in this case, maybe bt_ioremap() would be more
appropriate than fixmap, since there's no requirement that
virtual address be known at compile-time.

> [PATCH]serial: make early_uart to use early_prarm instead of console_initcall

s/prarm/param/

> new command line will be
> 
> earlycon=uart,io,0x3f8,9600n8
> earlycon=uart,io,0x3f8,9600n8 console=tty0
> earlycon=uart,mmio,0xff5e0000,115200n8

Why do we have to have a new "earlycon" argument?  Why can't we just
parse "console=uart" early?

BTW, if you want to convert it from "console=uart" to "console=8250",
as part of this cleanup, I think that would be OK.  Just make it a
separate patch and don't forget to change drivers/firmware/pcdp.c and
Documentation/kernel-parameters.txt at the same time.

Bjorn
