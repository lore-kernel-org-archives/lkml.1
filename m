Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXJUEcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXJUEcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXJUEcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:32:36 -0400
Received: from [212.12.190.249] ([212.12.190.249]:34264 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750754AbXJUEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:32:34 -0400
From: Al Boldi <a1426z@gawab.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [RFD] iptables: mangle table obsoletes filter table
Date: Sun, 21 Oct 2007 07:31:58 +0300
User-Agent: KMail/1.5
Cc: Bill Davidsen <davidsen@tmr.com>, Patrick McHardy <kaber@trash.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710120031.42805.a1426z@gawab.com> <200710200640.02012.a1426z@gawab.com> <26556.1192855654@turing-police.cc.vt.edu>
In-Reply-To: <26556.1192855654@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710210731.58959.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sat, 20 Oct 2007 06:40:02 +0300, Al Boldi said:
> > Sure, the idea was to mark the filter table obsolete as to make people
> > start using the mangle table to do their filtering for new setups.  The
> > filter table would then still be available for legacy/special setups. 
> > But this would only be possible if we at least ported the REJECT target
> > to mangle.
>
> That's *half* the battle.  The other half is explaining why I should move
> from a perfectly functional setup that uses the filter table.  What gains
> do I get from doing so?  What isn't working that I don't know about? etc?
>
> In other words - why do I want to move from filter to mangle?

This has already been explained in this thread; here it is again:

Al Boldi wrote:
>>>The problem is that people think they are safe with the filter table,
>>>when in fact they need the prerouting chain to seal things.  Right now
>>>this is only possible in the mangle table.
>>
>>Why do they need PREROUTING?
> 
> Well, for example to stop any transient packets being forwarded.  You could 
> probably hack around this using mark's, but you can't stop the implied
> route lookup, unless you stop it in prerouting.

Basically, you have one big unintended gaping whole in your firewall, that 
could easily be exploited for DoS attacks at the least, unless you put in 
specific rules to limit this.

Plus, it's outrageously incorrect to accept invalid packets, just because 
your filtering infrastructure can only reject packets after they have been 
prerouted.


Thanks!

--
Al

