Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZBEBbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZBEBbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZBEBap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:30:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:44782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbZBEBao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:30:44 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1233795431.15714.13.camel@localhost>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
	 <1233783502.4612.7.camel@pasglop>
	 <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
	 <1233794410.4612.34.camel@pasglop>  <1233795431.15714.13.camel@localhost>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 12:29:23 +1100
Message-Id: <1233797363.4612.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Yup, missed that change in the patch. In fact, I even missed the
> > existence of a WARN_ONCE that takes those text arguments... baaaah. I
> > suppose I should try to read more of lkml :-)
> 
> But don't expect to see them on powerpc, they never make it to the
> console.

Allright, that's the problem with our implementation of WARN using a
conditional trap, we don't carry all the variable arguments for the
printf over.

I'm tempted to turn our implementation back to normal C code with an if
and a branch out of line, but Michael seems to say that even with
appropriate use of unlikely() etc... gcc decides to generate the worst
possible code every single time ...

<rant>
such as always inlining the whole printf mumbo jumbo and having the
not-warning case branch over it, not -all- CPUs have good branch
prediction dude, so the icache is going to scream but gcc folks know
better of course....
</rant>

Anyway, I'll see Michael what exactly the situation is here and if we
can fix it a way or another.

Ben.


