Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXLJETA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXLJETA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXLJESw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:18:52 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37206 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXLJESv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:18:51 -0500
Message-ID: <475CBDD7.5050602@keyaccess.nl>
Date: Mon, 10 Dec 2007 05:17:27 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz>
In-Reply-To: <20071209212513.GC24284@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-12-07 22:25, Pavel Machek wrote:

> On Sun 2007-12-09 17:59:08, Andi Kleen wrote:

>> Yes, i guess switching to udelay at least on newer systems would
>> be a good idea.  I'm not quite sure about systems without TSC though.
> 
> Something like this? (Warning, will not probably even compile on
> x86-64, I do not have 64-bit compiler near me).

>  static inline void native_io_delay(void)
>  {
> -	asm volatile("outb %%al,$0x80" : : : "memory");
> +	udelay(8);
>  }

Alan, did you double-check that 8 us? I tried to but I seem to not have 
trustworthy documentation.

Rene.
