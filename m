Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0BAM55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:57:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51003 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752804Ab0BAM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:57:56 -0500
Date: Mon, 1 Feb 2010 12:58:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
Message-ID: <20100201125845.3f468363@lxorguk.ukuu.org.uk>
In-Reply-To: <20100201.044813.27473014.davem@davemloft.net>
References: <20100201110723.54870f7f@lxorguk.ukuu.org.uk>
	<20100201.031725.144446744.davem@davemloft.net>
	<20100201114824.29682015@lxorguk.ukuu.org.uk>
	<20100201.044813.27473014.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The old drivers contain a fair amount of crap, magic and gueswork so a
> > good deal of human analysis and testing is needed to move any change
> > around and prove it's real and valid not guesswork and fudging.
> 
> And then once that hard work is done, we kind of just toss it
> for one side of the equation?

I don't where you got that idea from.

The "merge" makes it harder to maintain both, adds lots of ifdefs and
artificial divisions of code stuffed into include files. Its ugly as sin
and makes *both* sets of drivers harder to maintain.

So it's quite clearly cheaper and more efficient to propogate any
relevant fixes both directions than produce a single ifdef and include
filled turdpile that can't be maintained at all. It's not as if either
set of drivers change on a regular basis.

Plus I'd point out the calling patterns, locking and the assumptions of
the two stacks are not quite the same. There are also things the old
stack can't do (eg hotplug, queued commands, intelligent serializing
of command sequences) or that the current stack can't do (generally
because they make no sense moving forward but also stuff like user
issued SETXFER snooping)

Alan
