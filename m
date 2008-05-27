Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYE0Dmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYE0Dmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 23:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYE0Dmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 23:42:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbYE0Dmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 23:42:46 -0400
Date: Mon, 26 May 2008 20:42:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080526204233.75b71bb8@infradead.org>
In-Reply-To: <20080526.192812.184590464.davem@davemloft.net>
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 19:28:12 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 27 May 2008 12:15:40 +1000
> 
> > Some of them. USB comes to mind. I'd be happy to make it "the rule"
> > and document that MMIO vs. coherent access aren't implicitely
> > ordered. I would still keep them ordered on powerpc for a little
> > while tho until I'm happy enough with driver auditing.
> > 
> > But heh, it's you who was telling me that it would be a bad
> > engineering decision and we had to make everybody look like x86 &
> > fully ordered :-) I decided to agree back then and stuck all those
> > nasty heavy barriers in the powerpc variants of readl/writel/...
> 
> I still believe this.
> 
> It's just another complicated thing for driver authors to get wrong.
> The other side of the coin is of course the cost.
> 
> The only thing I am absolutely sure of is that we should make a
> decision fast, document it, and just stick to it.

... and try to find a way to test for it at runtime or compile time.

either via sparse or some fancy lockdep like "device store" thing?
If we can't test for it and it doesn't show up on x86 ... it'll just be
an eterrnal chase.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
