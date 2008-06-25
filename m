Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYFYP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYFYP0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYFYP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:26:19 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2660 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753120AbYFYP0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:26:18 -0400
Date: Wed, 25 Jun 2008 19:26:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080625152615.GA18241@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <486244FF.8060805@ru.mvista.com> <20080625142249.GA21630@polina.dev.rtsoft.ru> <20080625153212.611c3766@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080625153212.611c3766@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 03:32:12PM +0100, Alan Cox wrote:
> > Note: I don't have any specifications on that ULi bridge, neither I have
> > any schematics for that board (so far, let's hope). So I can't say
> > exactly how things are inter-connected or what these PCI quirks are
> > actually doing (despite few comments in them).
> 
> So you don't for example know if the bridge is correctly configured for
> that device to be edge or level triggered ?

Nope. But I don't think that I can configure it anyway. The thing is
that this particular setup doesn't use ULi's i8259 PIC (it is disabled by
one of PCI quirks), and IDE interrupt is a sideband PCI-E interrupt (also
configured by the PCI quirk). So IDE interrupt is "directly" connected to
OpenPIC interrupt line (through the SOC PCI-E controller, of course).

If that ULi bridge (M1575) provides some other means of configuring, I
could try it... with the specifications.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
