Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZFZNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZFZNdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbZFZNdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:33:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45090 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755721AbZFZNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:33:32 -0400
Date: Fri, 26 Jun 2009 14:34:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626143446.2cf061f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626125111.GA11575@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
	<20090626101310.4110a290@lxorguk.ukuu.org.uk>
	<20090626093859.GA12571@elte.hu>
	<20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
	<20090626110429.GB12446@elte.hu>
	<20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
	<20090626122254.GA9959@elte.hu>
	<20090626133318.5b8de81b@lxorguk.ukuu.org.uk>
	<20090626125111.GA11575@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We will gladly take clean x86 patches that abstract away lowlevel 
> details of x86 platforms, and have been taking them and have been 
> writing them for a long time. If this patch-set can shape itself in 
> such a way (as i requested), without hindering the common case, it 
> is certainly welcome.

Lets try again shall we. I'l repeat the relevant bits of the mail you
quoted bits from and ignored almost all of

> The thing is, you are trying to defend a v1 patch-set here that is 
> really indefensible: it's ugly and deficient in numerous smaller and 
> larger details. I outlined numerous deficiencies already - and i'll 
> review v2 too to see what else is there to fix.  

No I'm trying to understand what you actually want the thing to look like.
Are we talking

/* Fixed struct not pointer for speed */
struct platform_ops platform_ops;
memcpy(platform_ops, platform_op_list[detect_platform_type()],
					sizeof(struct platform_ops));

platform->add_private_resources();
platform->timer_foo();
platfomr->timer_bar();

or

platform->init();
timer = platform->timer;

timer->begin()

