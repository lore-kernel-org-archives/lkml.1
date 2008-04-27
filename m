Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbYD0XBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbYD0XBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYD0XBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:01:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50110 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYD0XBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:01:42 -0400
Date: Sun, 27 Apr 2008 16:01:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427160120.5788118f@laptopd505.fenrus.org>
In-Reply-To: <20080427.154620.177583216.davem@davemloft.net>
References: <20080427214837.GA11631@elte.hu>
	<1209335660.3801.79.camel@localhost.localdomain>
	<4815009C.2010809@garzik.org>
	<20080427.154620.177583216.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 15:46:20 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jeff Garzik <jeff@garzik.org>
> Date: Sun, 27 Apr 2008 18:39:24 -0400
> 
> > I disagree with this semantics change.  A number of code places
> > _and drivers_ GET IT RIGHT, and these are all broken now?
> 
> [ Note, James's patch that you quoted is about mapping DMA
>   memory, in dma_declare_coherent_memory(), rather than devices.
>   But I know what you are trying to talk about Jeff. :-) ]
> 
> Wrt. ioremap() semanics, it is important to realize that if
> the implementation of this on x86 has been giving non-cached
> I/O mappings out up until recently, you can expect that there
> are hundreds of drivers that might now be broken.

it's even worse than that.
99% of the time it gave out uncached memory, but if the bios was iffy,
it would suddenly give out something else.

The changes to ioremap() recently turned that into "100% uncached".
For me, that's the right (because safe) behavior, exactly for the
reason you mentioned: it's what happened in practice, and driver writers
would assume that to happen.

Anything except uncached would just be insanity as default.
(well the old "whatever mood the bios writer was in, usually uncached" is
effectively uncached except for weird behaving boxes)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
