Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYGWUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYGWUcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYGWUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:32:14 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:46003 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbYGWUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:32:13 -0400
Date: Wed, 23 Jul 2008 22:21:48 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "x86@kernel.org" <x86@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20080723202148.GA2949@axis.com>
References: <200807172213.37411.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:13:37PM +0200, Denys Vlasenko wrote:
> Hi Andrew,
> 
> Here is the update against current Linus tree,
> rolled up into one patch.
> 
> James Bottomley suggested a different naming scheme:
> instead of swapping parts (.text.head -> .head.text),
> prepend .kernel to our special section names.
> This patch implements his idea.
> 
> ppc and v850 are dropped per comments from arch people.
> parisc and x86 had minor fixes. x86 fix added proper
> executable bits to a section:
> 
> -.section ".text.head"
> +.section ".kernel.text.head","ax",@progbits
> 
> Does arch/m68k/kernel/sun3-head.S need the same fix?
> 
> The patch is run-tested on x86_64.
> 
> I would like to ask arch maintainers to ACK/NAK this patch,
> and Andrew to act accordingly.
> 
> Changelog follows:
> 
> 
> 
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

CRIS part:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> vda

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
