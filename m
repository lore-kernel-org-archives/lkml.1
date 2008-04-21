Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYDUHq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYDUHq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYDUHqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:46:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:32808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYDUHqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wYRek/59fvXfy4lHPbohuhW62BKKgICPJki00qfdLnKYXVYOzoU2N5QeJpXk5W0aCtPfo68cc53f2uw+oWAL3kU0RB2wsPApPvrjL+LMcrxwYC4RleQ9O/isOX4i52WZj5w/N0/UtdcNscqtrD6B3ibexvmHd/L4GptKCCT6ExY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: x86: 4kstacks default
Date: Mon, 21 Apr 2008 09:45:24 +0200
User-Agent: KMail/1.8.2
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net>
In-Reply-To: <480B4DB4.8070107@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210945.24479.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 16:05, Eric Sandeen wrote:
> Adrian Bunk wrote:
> > But the more users will get 4k stacks the more testing we have, and the 
> > better both existing and new bugs get shaken out.
> > 
> > And if there were only 4k stacks in the vanilla kernel, and therefore 
> > all people on i386 testing -rc kernels would get it, that would give a 
> > better chance of finding stack regressions before they get into a 
> > stable kernel.
> 
> Heck, maybe you should make it 2k by default in all -rc kernels; that
> way when people run -final with the 4k it'll be 100% bulletproof, right?
>  'cause all those piggy drivers that blow a 2k stack will finally have
> to get fixed?  Or leave it at 2k and find a way to share pages for
> stacks, think how much memory you could save and how many java threads
> you could run!
> 
> 4K just happens to be the page size; other than that it's really just
> some random/magic number picked, and now dictated that if you (and
> everyting around you) doesn't fit, you're broken.

Some number has to be picked. Why fitting in 4k is "bad" and fitting
in 8k is "not bad"?

Look what happens when this number is too big: Windows is "generous",
and as a result Windows drivers routinely need 12k, sometimes 16k of stack.
We know it from ndiswrapper. We don't want to go that way, right?

Forget about 50k threads. 4k of waste per process is a waste nevertheless.
It's not at all unusual to have 250+ processes, and 250 processes with 8k
stack each waste 1M. Do you think extra 1M won't be useful to have?

It seems that 4k works for everybody sans xfs. Making it work took some effort,
but it is already done. Why not use it after all?

And since i386 is such a common architecture, other 32-bit arches will be
relieved from the burden of hunting down stack overflows which happen
only on those arches. (For example, different ABI or different gcc behavior
may make $OTHER_ARCH slightly more stack-greedy). God knows non-mainstream
arches have enough problems already.
--
vda
