Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbXGRC6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbXGRC6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 22:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXGRC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 22:57:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbXGRC55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 22:57:57 -0400
Date: Tue, 17 Jul 2007 19:56:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
 warnings
In-Reply-To: <adamyxuo2w6.fsf@cisco.com>
Message-ID: <alpine.LFD.0.999.0707171954230.27353@woody.linux-foundation.org>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
 <ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>
 <adamyxuo2w6.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Roland Dreier wrote:
>
> So setting a variable to something meaningless (guaranteeing that a 
> garbage value is used in case of a bug) just to shut up a warning makes 
> no sense -- it's no safer than leaving the code as is.  

Wrong.

It's safer for two reasons:
 - now everybody will see the *same* behaviour
 - the "meaningless value" is guaranteed to not be a security leak

but the whole "shut up bogus warnings" is the best reason.

So it *is* safer than leaving the code as-is.

Of course, usually the best approach is to rewrite the code to be simpler, 
so that even gcc sees that something is obviously initialized. Sadly, 
people seldom do the right thing, and sometimes gcc just blows incredibly 
hard.

		Linus
