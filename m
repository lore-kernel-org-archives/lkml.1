Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYGRIuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYGRIuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYGRIu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:50:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYGRIu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:50:27 -0400
Date: Fri, 18 Jul 2008 10:48:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible
	with -ffunction-sections -fdata-sections
Message-ID: <20080718084844.GM6875@elte.hu>
References: <200807172213.37411.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Denys Vlasenko <vda.linux@googlemail.com> wrote:

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

Acked-by: Ingo Molnar <mingo@elte.hu>

could you please put the ax/progbits fix in front of the queue so that 
it becomes bisectable and so that the later patches keep their "it 
should not change anything" property?

I.e. do not mix small fixlets into a large set of "no change" patches - 
split them out in front. This is really important for the x86 bits as 
linker script changes tend to be quite fragile.

	Ingo
