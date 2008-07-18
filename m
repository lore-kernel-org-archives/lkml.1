Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYGRMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYGRMCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbYGRMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:02:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbYGRMCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:02:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
References: <200807172213.37411.vda.linux@googlemail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible with -ffunction-sections -fdata-sections
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 18 Jul 2008 12:53:08 +0100
Message-ID: <14472.1216381988@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> wrote:

> The purpose of these patches is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> 
> The problem is that with -ffunction-sections -fdata-sections gcc
> creates sections like .text.head and .data.nosave
> whenever someone has innocuous code like this:
> 
> static void head(...) {...}
> 
> or this:
> 
> int f(...) { static int nosave; ... }
> 
> somewhere in the kernel.
> 
> Kernel linker script is confused by such names and puts these sections
> in wrong places.
> 
> This patch renames all "magic" section names used by kernel
> to not have this format, eliminating the possibility of such collisions.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Acked-by: David Howells <dhowells@redhat.com> [FRV and MN10300]
