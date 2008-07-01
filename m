Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYGAXlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYGAXlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbYGAXlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:41:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55689 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbYGAXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:41:08 -0400
Subject: Re: [PATCH 14/23] make section names compatible with
	-ffunction-sections -fdata-sections: parisc
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
In-Reply-To: <200807020239.11410.vda.linux@googlemail.com>
References: <200807020239.11410.vda.linux@googlemail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 01 Jul 2008 18:41:00 -0500
Message-Id: <1214955660.3316.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 02:39 +0200, Denys Vlasenko wrote:
> The purpose of this patch is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> This patch fixes parisc architecture.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Um ... if you look at the Makefile you'll see we already build parisc
with -ffunction-sections; we have to: our relative jumps are too small
to guarantee finding the stubs in large files.

Since our text is -ffunction-sections compatible already, I question the
need for transformations like this:

> ﻿-               *(.text.do_softirq)
> -               *(.text.sys_exit)
> -               *(.text.do_sigaltstack)
> -               *(.text.do_fork)
> +               *(.do_softirq.text)
> +               *(.sys_exit.text)
> +               *(.do_sigaltstack.text)
> +               *(.do_fork.text)

And thus by the same token the data transformations.

James


