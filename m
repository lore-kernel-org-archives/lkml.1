Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYDTOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYDTOFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYDTOFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:05:42 -0400
Received: from sandeen.net ([209.173.210.139]:16016 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYDTOFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:05:41 -0400
Message-ID: <480B4DB4.8070107@sandeen.net>
Date: Sun, 20 Apr 2008 09:05:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi>
In-Reply-To: <20080420121803.GK1595@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

> But the more users will get 4k stacks the more testing we have, and the 
> better both existing and new bugs get shaken out.
> 
> And if there were only 4k stacks in the vanilla kernel, and therefore 
> all people on i386 testing -rc kernels would get it, that would give a 
> better chance of finding stack regressions before they get into a 
> stable kernel.

Heck, maybe you should make it 2k by default in all -rc kernels; that
way when people run -final with the 4k it'll be 100% bulletproof, right?
 'cause all those piggy drivers that blow a 2k stack will finally have
to get fixed?  Or leave it at 2k and find a way to share pages for
stacks, think how much memory you could save and how many java threads
you could run!

4K just happens to be the page size; other than that it's really just
some random/magic number picked, and now dictated that if you (and
everyting around you) doesn't fit, you're broken.

That bugs me.

-Eric

(yes, I know there are advantages to only allocating a single page for a
new thread, but from an "all callchains after that must fit in that
space" perspective, it's just a randomly picked number)
