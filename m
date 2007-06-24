Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbXFXP3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbXFXP3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXFXP3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:29:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40909 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXFXP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:29:31 -0400
X-Originating-Ip: 74.102.207.204
Date: Sun, 24 Jun 2007 11:25:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "upping" a semaphore from interrupt context?
In-Reply-To: <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706241123130.7006@localhost.localdomain>
References: <20070622173839.GB8398@iucha.net>  <200706221934.18436.arnd@arndb.de>
  <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain> 
 <200706231402.03617.arnd@arndb.de>  <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
  <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain>
 <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> On 6/23/07, Robert P. J. Day <rpjday@mindspring.com> wrote:

> > hang on, how is that true?  as i read it, mutexes are more than
> > just binary semaphores -- they have additional restrictions that
> > regular semaphores don't.
>
> Yes, they do have additional restrictions (mutex_trylock() illegal
> from contexts that cannot sleep, mutexes may only be unlocked by
> tasks that took them in the first place). But note that these are
> _implementation_ sanity checks that were introduced to catch
> nonsensical usage, which was possible (and not explicitly being
> guarded against, because of the generic-ness that was needed to be
> maintained for the counted case too) with the "semaphore"s.
>
> > so i'm not convinced that binary semaphores can simply be replaced
> > by mutexes, unless that's not what you meant here.
>
> I do mean precisely that. I really cannot think of any sensible /
> normal usage case of binary semaphores that cannot be replaced with
> either mutexes (if that's the kind of locking you actually want) or
> completion handlers (if that's the kind of synchronization you
> actually want).

ok, i can see what you're getting at now.  i'm just going to have to
convince myself that, once you have mutexes and completions, you have
no further need for even general counting semaphores.

rday
