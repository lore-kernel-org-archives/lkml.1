Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXFSWba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXFSWba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbXFSWbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:31:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1325 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbXFSWbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:31:22 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
Date: Wed, 20 Jun 2007 00:31:05 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org> <200706192337.49505.m.kozlowski@tuxland.pl> <alpine.LFD.0.98.0706191443460.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706191443460.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706200031.07082.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	MAINTAINERS says riscom8 is orphaned so not sure
> > if anybody cares. Spotted this when playing with modprobe
> > walking /lib/modules/`uname -r`/kernel in a loop ;)
> 
> Oh wow.
> 
> I wonder why it does that. The code literally does:
> 
>         save_flags(flags);
>         cli();
>         tty_unregister_driver(riscom_driver);
>         put_tty_driver(riscom_driver);
>         restore_flags(flags);
> 
> and I don't see the point.
> 
> (And that's what then causes the warning: tty_unregister_driver will 
> eventually get a mutex, but the caller had disabled hardware interrupts..
> 
> I see absolutely *zero* reason for that whole save_flags/cli/restore_flags 
> dance at all, so I think the right thing to do is to just remove it.
> 
> I'm Cc'ing Alan, in case he cares. 
> 
> Mariusz, if you actually *use* the dang thing, and really care, you can 
> send me a tested patch. I can pretty much guarantee that removing those 
> irq games won't make things any worse, but no way am I going to just 
> remove it on my own without any users or any testing.

Unfortunately I can test it only the way I did it so far. That means no real
hardware :-/ This also implies I do care but not that much ;-) If you want any
patches to be tested that way -> feel free to mail me.

	Mariusz
