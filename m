Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYH1Nu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYH1Nu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYH1NuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:50:16 -0400
Received: from mout2.freenet.de ([195.4.92.92]:34947 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYH1NuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:50:15 -0400
Date: Thu, 28 Aug 2008 15:50:09 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080828135009.GA11431@tux1.brauer.lan>
References: <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080827161346.35b48d75@doriath.conectiva> <20080827233328.GC25531@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080827233328.GC25531@Krystal>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 07:33:28PM -0400, Mathieu Desnoyers wrote:
> 
> We could try to add some nsleep() or msleep() calls within text_poke and
> text_poke_early before and after the code modificatoin to see if the
> problem disappears. If it does, then that would somewhat confirm the
> racy irq disable thesis.

nsleep isn't known here as a function, only references i found is maybe
in posix-timers.c.

msleep() is known, but each time i add for ex.
msleep(100);
in any place in text_poke and/or text_poke_early it get a kernel panic
on boot. Here's a screenie:
http://users.archlinux.de/~gerbra/tmp/2008-08-28-132337_724x456_scrot.png

I also tried to work with the isolated changes we have last made, but it
seems that only the 3 changes together work.
Also i tried to went back to older versions of alternatives.c referenced
in:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=history;f=arch/x86/kernel/alternative.c;h=65c7857a90ddfc6ff084c6817baba045ced0ad71;hb=v2.6.26

But with my few knowledges i ran in too many errors.

So, have you any further ideas, code that i/we could test?
Or - i'm naive - are the "3 changes" we made ready to go in the kernel
without to harm something real important than virtualbox?

> Mathieu

Gerhard


