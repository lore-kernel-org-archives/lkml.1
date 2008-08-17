Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYHQHxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYHQHxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 03:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYHQHw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 03:52:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48616
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbYHQHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 03:52:56 -0400
Date: Sun, 17 Aug 2008 00:52:55 -0700 (PDT)
Message-Id: <20080817.005255.28108612.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: adobriyan@gmail.com, jirislaby@gmail.com, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
 write_trylock_irqsave
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0808161417400.3324@nehalem.linux-foundation.org>
References: <48A6D694.4070302@gmail.com>
	<20080816204855.GA5151@martell.zuzino.mipt.ru>
	<alpine.LFD.1.10.0808161417400.3324@nehalem.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Aug 2008 14:21:41 -0700 (PDT)

> 
> 
> On Sun, 17 Aug 2008, Alexey Dobriyan wrote:
> 
> > On Sat, Aug 16, 2008 at 03:31:00PM +0200, Jiri Slaby wrote:
> > >
> > > Doesn't this break on sparc -- is it tested there?
> > 
> > What's so special about sparc?
> 
> Sparc _used_ to save/restore the whole processor flags word with the irq 
> flags. That includes, iirc, things like the register window crap, so if 
> you did a save/restore flags in a function, it would get all that wrong 
> and things would blow up.
> 
> However, I don't think sparc has actually done that for a _loong_ time 
> now, due to it always being problematic.

We fixed it.

Although I still sometimes consider saving and restoring cpu IRQ flags
in different function contexts to be on the ugly side :)
