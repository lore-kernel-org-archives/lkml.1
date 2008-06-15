Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYFOXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYFOXds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYFOXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:33:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:65052 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751644AbYFOXdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:33:39 -0400
Date: Mon, 16 Jun 2008 00:31:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <alpine.LFD.1.10.0806141654280.2949@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.55.0806160001430.11995@cliff.in.clinika.pl>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
 <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
 <Pine.LNX.4.55.0806142249090.3771@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806141654280.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008, Linus Torvalds wrote:

> >  From what you have written it looks the dependency should actually be:
> > 
> > 	depends on !M386 && !M486 && !M586 && !M586TSC && !M586MMX
> > 
> > as none of the pre-Pentium-Pro processors had the PAE feature (I am not
> > sure about non-Intel implementations, so the case of M586 would have to be
> > investigated).
> 
> Yes, it's the non-intel ones that would keep me from saying !M586.
> 
> For intel, PAE was a PPro feature (at least officially, as you point out), 
> but I do not know about various other manufacturers. From personal 
> experience, the line between Pentium and PPro features doesn't tend to be 
> totally black-and-white (although I suspect that when it comes to PAE it 
> _may_ be).

 Well, PAE is quite a significant block to implement and Intel kept it
hidden until they published the long awaited PentiumPro manual sometime in
1996.  I am fairly sure the K5 did not implement it (it may have had PSE 
and VME, especially in the later revisions) and Google does not show up 
any Cyrix processors with PAE.  I may have a K5 manual somewhere, so I can 
see if I can verify it.

 Please also note these processors tried to compete with Intel on the
desktop market where 4GB of RAM was completely unreasonable in late 90s.  
I think unless someone can recall a counter-example, it can be safely
assumed these chips did not have the PAE.  We could try to extend the
dependency and see if anybody screams.

  Maciej
