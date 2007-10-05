Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbXJEX2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbXJEX2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXJEX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:28:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:40956 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbXJEX16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:27:58 -0400
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Timur Tabi <timur@freescale.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Andreas Schwab <schwab@suse.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4706A096.4000700@freescale.com>
References: <4706822D.4070509@freescale.com>
	 <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	 <470691EB.7020209@freescale.com>
	 <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
	 <470694E0.7030408@freescale.com> <jed4vtnxa5.fsf@sykes.suse.de>
	 <47069982.9030009@freescale.com>
	 <Pine.LNX.4.61.0710051623060.29533@chaos.analogic.com>
	 <4706A096.4000700@freescale.com>
Content-Type: text/plain
Date: Sat, 06 Oct 2007 09:27:21 +1000
Message-Id: <1191626841.6416.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-05 at 15:37 -0500, Timur Tabi wrote:
> linux-os (Dick Johnson) wrote:
> 
> > It makes no sense because a bitfield is something having to
> > do with a 'C' compiler and it must NEVER be used as a template
> > to address hardware! 'C' gives no guarantee of the ordering
> > within machine words. The only way you can access them is
> > using 'C'. They don't have addresses like other objects
> > (of course they do exist --somewhere). They are put into
> > "storage units," according to the standard, and these
> > storage units are otherwise undefined although you can
> > align them (don't go there).
> 
> Well, if it doesn't make any sense why do we have __LITTLE_ENDIAN_BITFIELD and 
> __BIG_ENDIAN_BITFIELD?  That is, why do we do this:

.../... (snipped horror use of bitfields)

Bitfields are wrong. Period. Don't use them.

__LITTLE_ENDIAN_BITFIELD vs. __BIG_ENDIAN_BITFIELD is Linux way to cope
with existing code using them that needs fixing on architectures that
have C bitfields in reverse order but that's not even something that can
be properly relied upon generally.

Just don't use bitfields and be happy.

Ben.


