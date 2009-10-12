Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbZJLRsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbZJLRsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932633AbZJLRsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:48:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481AbZJLRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:48:08 -0400
Date: Mon, 12 Oct 2009 10:46:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
In-Reply-To: <alpine.LFD.2.01.0910121036330.3438@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910121044331.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>  <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>  <20091012113758.GB11035@elte.hu>  <20091012140149.6789efab@marrow.netinsight.se>  <20091012120951.GA16799@elte.hu> 
 <1255349748.10605.13.camel@macbook.infradead.org>  <20091012122023.GA19365@elte.hu>  <20091012150650.51a4b4dc@marrow.netinsight.se>  <20091012131528.GC25464@elte.hu>  <20091012153937.0dcd73e5@marrow.netinsight.se>  <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
  <alpine.LFD.2.01.0910120837030.3438@localhost.localdomain> <1255368557.27022.226.camel@localhost> <alpine.LFD.2.01.0910121036330.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Linus Torvalds wrote:
> 
> Once you do the final flush in a controlled place _after_ you've printed 
> out all the oops information, you simply don't care about locks any more. 
> Because if you were holding critical locks, you're done anyway.
> 
> Sure, maybe you want to do a "trylock()" and skip the oops flush entirely 
> in the mtd layer if you can't do it, but it's the "let's use a workqueue" 
> or something that doesn't seem to make a lot of sense to me.

Side note: I don't actually care deeply. Once it's all inside some driver, 
and once it's not messing up the console layer, I don't think the small 
details matter all that much. I just think it's likely to be a sign of 
something wrong if you need to use workqueues to flush - it probably means 
that the most interesting oopses will never make it to the mtd device in 
the first place.

			Linus
